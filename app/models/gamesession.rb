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
        puts "╔═" + line + "═╗"
        puts "║ " + puzzle + " ║"
        puts "╚═" + line + "═╝"
        flag = false
        while flag == false && tries > 0 && puzzle.include?("_")
        puts "\n\nTo exit the game, enter EXIT\nTo guess a letter, enter a letter.\nFor a hint, enter HINT\n#{tries} tries remaining.\n\n"
            guess = gets.chomp
            system('clear')
            if guess.upcase == "EXIT"
                # ! exit game function here
                # ! self.win = false
                flag = true
            elsif guess == "HINT"
                puts "A synonym for the puzzle word is #{hint}.\n\n"
            elsif guess.length == 1 && "abcdefghijklmnopqrstuvwxyz".include?(guess.downcase)
                if word.include?(guess)
                    for i in 1..word.count(guess)
                        puzzle[word.index(guess)*2] = guess
                        word[word.index(guess)] = "_"
                    end
                    puts "╔═" + line + "═╗"
                    puts "║ " + puzzle + " ║"
                    puts "╚═" + line + "═╝"
                    if wrong != ""
                        puts "Incorrect Guesses: #{wrong}"
                    end
                else
                    tries -= 1
                    wrong << guess + "  "
                    puts "Sorry, #{guess} is not in the word."
                    puts "╔═" + line + "═╗"
                    puts "║ " + puzzle + " ║"
                    puts "╚═" + line + "═╝"
                    puts "Incorrect Guesses: #{wrong}"
                end
            else
                puts "Invalid input!  Please try again."
                puts "╔═" + line + "═╗"
                puts "║ " + puzzle + " ║"
                puts "╚═" + line + "═╝"
                puts "Incorrect Guesses: #{wrong}"
            end
        end

        if tries == 0
            self.win = false
        elsif !puzzle.include?("_")
            self.win = true
            puts "\n\nYou solved the puzzle!\n\n"
            user = User.find(self.user_id)
            menu(user)
        end
    end

    def get_hint(word)
        th_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=b026f64f-2167-4a30-8f7c-6effdf95c336"
        response = RestClient.get(th_url)
        obj = JSON.parse(response)
        hint = obj[0]["meta"]["syns"].flatten.sample
    end

    def render_puzzle

    end
end