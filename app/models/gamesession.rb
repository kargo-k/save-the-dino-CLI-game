class GameSession < ActiveRecord::Base
    has_many :words
    has_many :users

    def start_game
        word = Word.find(self.word_id).word
        hint = get_hint(word)
        hint_flag = false
        tries = 6
        puzzle = ""
        line = ""
        wrong = ""
        for i in 1..word.length
            puzzle << "_ "
            line << "══"
        end
        
        status = "Let's begin!  Here's your puzzle, #{User.find(self.user_id).name}.  Good luck!"
        render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)

        flag = false
        while flag == false && tries > 0 && puzzle.include?("_")
            puts "\n\nTo guess a letter, enter a letter.\nFor a hint, enter HINT (uses a try)\n#{tries} tries remaining.\n\nTo exit the game, enter EXIT"
            print ">> "
            guess = gets.chomp
            guess = guess.downcase
            if guess.upcase == "EXIT"
                self.win = false
                self.save
                flag = true
                end_program
            elsif guess.upcase == "HINT"
                hint_flag = true
                tries -= 1
                render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)

            elsif guess.length == 1 && "abcdefghijklmnopqrstuvwxyz".include?(guess)
                if word.include?(guess)
                    for i in 1..word.count(guess)
                        puzzle[word.index(guess)*2] = guess
                        word[word.index(guess)] = "_"
                    end
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                elsif wrong.include?(guess) || puzzle.include?(guess)
                    status = "You already guessed that letter..."
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                else
                    tries -= 1
                    wrong << guess + "  "
                    status = "Sorry, #{guess} is not in the word."
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                end
            else
                status = "Invalid input!  Please try again."
                render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            end
        end

        user = User.find(self.user_id)

        if tries == 0
            self.win = false
            self.save
            status = "The solution was: #{Word.find(self.word_id).word}."
            render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            menu(user)

        elsif !puzzle.include?("_")
            self.win = true
            self.save
            status = "You solved the puzzle!"
            render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            self_records(user)
        end
    end

    def get_hint(word)
        th_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=b026f64f-2167-4a30-8f7c-6effdf95c336"
        response = RestClient.get(th_url)
        obj = JSON.parse(response)
        
        dic_url = "https://dictionaryapi.com/api/v3/references/collegiate/json/#{word}?key=fcaaacd2-b734-4cfb-8946-ff1484435c66"
        dict_response = RestClient.get(dic_url)
        dict_obj = JSON.parse(dict_response)

        if obj[0].class != String
            hint = obj[0]["meta"]["syns"].flatten.sample + " (synonym)"
        elsif dict_obj[0]["shortdef"] != nil
            hint = dict_obj[0]["shortdef"].flatten.first
        else
            hint = "Experts and Masters don't need no hints."
            tries += 1
        end
        return hint 
    end

    def render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
        system('clear')
        puts "╔═" + line + "╗"
        puts "║ " + puzzle + "║"
        puts "╚═" + line + "╝"
        if wrong != ""
            puts "Incorrect Guesses: #{wrong}"
        end
        if hint_flag == true
            puts "Your hint: #{hint}"
        else
            puts "\n"
        end
        puts "\n#{status}\n\n"
    end
end