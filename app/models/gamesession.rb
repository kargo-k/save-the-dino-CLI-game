class GameSession < ActiveRecord::Base
    has_many :words
    has_many :users

    def start_game(word = "")
        if word == ""
            word = Word.find(self.word_id).word
        end
        hint = get_hint(word)
        hint_flag = false
        tries = 6
        puzzle = ""
        line = ""
        wrong = ""
        solution = ""
        for i in 1..word.length
            solution << "#{word[i-1]} "
            puzzle << "_ "
            line << "══"
        end
        
        status = "Let's begin!  Here's your puzzle, #{User.find(self.user_id).name}.  Good luck!"
        render_dino(tries)
        render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)

        # while the guessed letters are not equal to the solution and while the player has more than 0 tries
        while puzzle != solution && tries > 0
            puts "\n\nTo guess a letter, enter a letter.\nTo guess a word, enter " + "SOLVE ".blue + "(uses a try)\n" + "For a hint, enter " + "HINT ".green + "(uses a try)\n#{tries} tries remaining.\n\nTo exit the game, enter " + "EXIT.".red
            print ">> "
            guess = gets.chomp
            guess = guess.downcase
            if guess == "showmetheanswer"
                status = "The solution is... #{Word.find(self.word_id).word}..."
                render_dino(tries)
                render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            elsif guess.upcase == "EXIT"
                self.win = false
                self.save
                puzzle = solution
                end_program
            elsif guess.upcase == "HINT"
                if hint_flag == false
                    hint_flag = true
                    tries -= 1
                    if hint.include?("Experts and Masters don't need no hints.")
                        tries += 1
                    end
                else 
                    tries = tries
                end
                render_dino(tries)
                render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            elsif guess.upcase == "SOLVE"
                print "\n\nEnter your solution: \n>> "
                guess_word = gets.chomp
                guess_word = guess_word.downcase
                if guess_word == Word.find(self.word_id).word
                    puzzle = solution
                else
                    tries -= 1
                    wrong << guess_word + " "
                    status = "Sorry, #{guess_word} is not the answer."
                    render_dino(tries)
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                end
            elsif guess.length == 1 && "abcdefghijklmnopqrstuvwxyz".include?(guess)
                if word.include?(guess)
                    for i in 1..word.count(guess)
                        puzzle[word.index(guess)*2] = guess
                        word[word.index(guess)] = "_"
                        status = "Getting closer!"
                    end
                    render_dino(tries)
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                elsif wrong.include?(guess) || puzzle.include?(guess)
                    status = "You already guessed that letter..."
                    render_dino(tries)
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                else
                    tries -= 1
                    wrong << guess + "  "
                    status = "Sorry, #{guess} is not in the word."
                    render_dino(tries)
                    render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
                end
            else
                status = "Invalid input!  Please try again."
                render_dino(tries)
                render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            end
        end

        user = User.find(self.user_id)

        if tries == 0
            self.win = false
            self.save
            status = "The solution was: " + "#{Word.find(self.word_id).word}".blue.underline
            render_dino(tries)
            render_puzzle(solution,line,wrong,hint,hint_flag,tries,status)
            user.self_records

        elsif !puzzle.include?("_")
            self.win = true
            self.save
            status = "You solved the puzzle!"
            render_happy_dino
            render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
            user.self_records
        end
    end

    def get_hint(word)
        th_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=b026f64f-2167-4a30-8f7c-6effdf95c336"
        response = RestClient.get(th_url)
        obj = JSON.parse(response)
        
        dic_url = "https://dictionaryapi.com/api/v3/references/collegiate/json/#{word}?key=fcaaacd2-b734-4cfb-8946-ff1484435c66"
        dict_response = RestClient.get(dic_url)
        dict_obj = JSON.parse(dict_response)

        wikiurl = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=description&titles=#{word}"
        wiki_resp = RestClient.get(wikiurl)
        wiki_obj = JSON.parse(wiki_resp)

        if obj[0].class != String && !obj.empty?
            hint = obj[0]["meta"]["syns"].flatten.sample + " (synonym)"
        elsif dict_obj[0].class == Hash
            hint = dict_obj[0]["shortdef"].flatten.first
        else wiki_obj.keys.length >= 1
            x = wiki_obj.dig("query", "pages")
            hint = x.values.first.dig("description")
            if hint == nil || hint == "Disambiguation page providing links to topics that could be referred to by the same search term"
                hint = "Experts and Masters don't need no hints."
            end
        end
        return hint 
    end

    def render_puzzle(puzzle,line,wrong,hint,hint_flag,tries,status)
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
        puts "\n#{status}\n"
    end

    def render_dino(tries)
        system('clear')
        case tries
        when 6
            puts " \n\n\n\n\n"
            puts "                        ___
                       / '_) 'RAWR'
                .-^^^-/ /
            ___/       /
            ¯¯¯¯|_|-|_|".green
        when 5
            puts "  .  <-asteroid\n\n\n\n".red
            puts "                            ___
                           / '_) 'rawr'
                    .-^^^-/ /
                ___/       /
                ¯¯¯¯|_|-|_|".green
        when 4
            puts "  o  <-asteroid getting bigger...\n\n\n\n".red
            puts "                            ___
                           / '_) 'rawr?'
                    .-^^^-/ /
                ___/       /
                ¯¯¯¯|_|-|_|".green
        when 3
            puts "  O\n\n\n\n ".red
            puts "                            ___
                           / '_) 'uhh'
                    .-^^^-/ /
                ___/       /
                ¯¯¯¯|_|-|_|".green
        when 2
            puts " ,gRg,  
Yb   dP 
 \"8g8\" \n\n".red
            puts "                            ___
                           / '_) '?!?!'
                    .-^^^-/ /
                ___/       /
                ¯¯¯¯|_|-|_|".green
        when 1
            puts " ,gPPRg,  
dP'   `Yb 
8)     (8
Yb     dP 
 \"8ggg8\" ".red
            puts "                            ___
                           / '_) 'halp!'
                    .-^^^-/ /
                ___/       /
                ¯¯¯¯|_|-|_|".green
        else
puts "
     _,,ddP***Ybb,,_         
   ,dP             Yb,         
 ,d                   b,        
 d                      b        
d                        b        
8                         8        
8                         8        
8                         8        
 Y,                      ,P        
  Ya                    aP         
   Ya                 aP          
     Yb,_         _,dP           
         YbbgggddP             ".red
puts "                      'ow.'".green
        end
    end
    def render_happy_dino
        system('clear')
        user = User.find { |user| self.user_id == user.id }
        puts " \n\n\n\n\n "
            puts "                         " + "/\\".blue.underline + "_".green + "
                        / '_) 'YAY, thank you #{user.name}'
                .-^^^-/ /
            ___/       /
            ¯¯¯¯|_|-|_|".green
    end
end