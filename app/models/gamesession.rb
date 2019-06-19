class GameSession < ActiveRecord::Base
    has_many :words
    has_many :users

    def start_game
        word = Word.find(self.word_id).word
        hint = get_hint(word)
        tries = 6
        puzzle = ""
        line = ""
        wrong = ""
        for i in 1..word.length
            puzzle << "_ "
            line << "══"
        end
        
        render_puzzle(puzzle,line)
        puts "Let's begin!  Here's your puzzle, #{User.find(self.user_id).name}"

        flag = false
        while flag == false && tries > 0 && puzzle.include?("_")
            puts "\n\nTo exit the game, enter EXIT\nTo guess a letter, enter a letter.\nFor a hint, enter HINT\n#{tries} tries remaining.\n\n"
            print ">>"
            guess = gets.chomp
            guess = guess.downcase
            if guess.upcase == "EXIT"
                self.win = false
                self.save
                flag = true
            elsif guess.upcase == "HINT"
                hint_flag = true
                render_puzzle(puzzle,line)
                puts "Your hint: #{hint}"
            elsif guess.length == 1 && "abcdefghijklmnopqrstuvwxyz".include?(guess)
                if word.include?(guess)
                    for i in 1..word.count(guess)
                        puzzle[word.index(guess)*2] = guess
                        word[word.index(guess)] = "_"
                    end
                    render_puzzle(puzzle,line)
                    if wrong != ""
                        puts "Incorrect Guesses: #{wrong}"
                    end
                    if hint_flag == true
                        puts "Your hint: #{hint}"
                    end
                else
                    tries -= 1
                    wrong << guess + "  "
                    puts "Sorry, #{guess} is not in the word."
                    render_puzzle(puzzle,line)
                    puts "Incorrect Guesses: #{wrong}"
                    if hint_flag == true
                        puts "Your hint: #{hint}"
                    end
                end
            else
                puts "Invalid input!  Please try again."
                render_puzzle(puzzle,line)
                puts "Incorrect Guesses: #{wrong}"
                if hint_flag == true
                    puts "Your hint: #{hint}"
                end
            end
        end

        if tries == 0
            self.win = false
            self.save
            puts "The solution was: #{Word.find(self.word_id).word}."
        elsif !puzzle.include?("_")
            self.win = true
            self.save
            puts "\n\nYou solved the puzzle!\n\n"
            user = User.find(self.user_id)
            menu(user)
        end
    end

    def get_hint(word)
        th_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=b026f64f-2167-4a30-8f7c-6effdf95c336"
        response = RestClient.get(th_url)
        obj = JSON.parse(response)
        if obj[0].class != String
            hint = obj[0]["meta"]["syns"].flatten.sample + " (synonym)"
        else
            dic_url = "https://dictionaryapi.com/api/v3/references/collegiate/json/#{word}?key=fcaaacd2-b734-4cfb-8946-ff1484435c66"
            response = RestClient.get(dic_url)
            obj = JSON.parse(response)
            hint = obj[0]["shortdef"].flatten.first
        end
        return hint 

    end

    def render_puzzle(puzzle,line)
        system('clear')
        puts "╔═" + line + "═╗"
        puts "║ " + puzzle + " ║"
        puts "╚═" + line + "═╝"
    end
end