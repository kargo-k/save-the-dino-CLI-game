#Welcome method prints the welcome message when called from the run.rb file
def welcome
    system('clear')
    system("printf '\e[8;50;93t'")
    puts "                                                              
      ,---.                    |    |             ,--. o          
      `---.,---..    ,,---.    |--- |---.,---.    |   |.,---.,---.
          |,---| \\  / |---'    |    |   ||---'    |   |||   ||   |
      `---'`---^  `'  `---'    `---'`   '`---'    `--' ``   '`---'
                                                                  "
    puts "\n\n"
end
#getplayername method prompts the user to input a username which then creates a user object and saves it to the database or gets the already existing user object from the database
def getplayername
    puts "Enter your username:\n\n"
    puts "To exit the game, enter " + "EXIT\n\n".red

    print ">> "
    name = gets.chomp
    system('clear')
    if name.downcase == "exit" #if user input is exit, end the app
        end_program
        return nil
    elsif User.all.any? { |user| user.name.downcase == name.downcase } #if the user exists, get the user object
        user = User.all.select { |user| user.name.downcase == name.downcase}[0]
        puts "Welcome back, #{user.name}\n\n"
    else #create the user and give them a how to play instructions method call instead of just going to menu
        user = User.create(name: name)
        how_to_play(user)
    end
    user
end 
#the hub in which the user selects what to do within the app, using a loop do statment allows for the user to input until they pick a correct option, if the object passed in is nil from the getplayername method the menu simply exits.
def menu(user)
    if user == nil
        return nil
    end
    puts "Make your selection (1-5):"
    puts "  1. Start New Game"
    puts "  2. View Leaderboard"
    puts "  3. View your Records"
    puts "  4. Change your Username"
    puts "  5. Delete your Username and Exit\n\n"
    puts "To exit the game, enter " + "EXIT\n\n".red
    print ">> "

    input = gets.chomp
    caseput = input.downcase
    loop do
        case input
        when "1"
            select_difficulty(user)
            break
        when "2"
            view_leaderboard(user)
            break
        when "3"
            system('clear')
            user.self_records
            break
        when "4"
            user.update_username
            break
        when "5"
            user.delete_user
            break
        when "exit"
            system('clear')
            end_program
            break
        else
            puts "Error, #{input} is not 1-5, try again"
            print ">> "
            input = gets.chomp
        end
    end
end

# Prompts the user to select a difficulty level between 1-5 then calls startgame with a word of that difficulty, again uses a loop do to ensure valid imput from the user.
def select_difficulty(user)
    system('clear')
    puts "Choose Difficulty (1-5):"
    difstr_arr = ["Easy","Medium","Hard","Expert","Master"]
    puts "  1. #{difstr_arr[0]}"
    puts "  2. #{difstr_arr[1]}"
    puts "  3. #{difstr_arr[2]}"
    puts "  4. #{difstr_arr[3]}"
    puts "  5. #{difstr_arr[4]}\n\n"

    print ">> "
    input = gets.chomp
    loop do
        case input.to_i
        when 1..5
            intdif = input.to_i
            word = select_word(intdif)
            current_sesh = GameSession.create(user_id: user.id, word_id: word.id)
            current_sesh.start_game
            break
        else
            puts "Error, #{input} is not 1-5, try again"
            print ">> "
            input = gets.chomp
        end
    end
end

# selects a random word from the library based on the difficulty level chosen by the user.  Code Credit: https://hashrocket.com/blog/posts/rails-quick-tips-random-records
def select_word(dif_lvl)
    case dif_lvl
    when 1 # easy difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 0..1000).first
    when 2 # medium difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 1001..100000).first
    when 3 # hard difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 100001..200000).first
    when 4 # expert difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 200001..400000).first
    when 5 # master difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 400001..Word.maximum(:difficulty)).first
    end
end
# goes through all game session objects in the database and all game sessions where the win value is true to return the top 5 players in the database in a table created with the print table method
def view_leaderboard(user)
    system('clear')
    winpercenthash = {}
    gd = {}
    i = 0
    noncheated = GameSession.all.select do |game| 
        game.word_id != nil
    end
    arrtotal = noncheated.map do |game|
        User.find(game.user_id)
    end
    arrwin = noncheated.select do |game|
        game.win == true
    end
    arrwin.map! do |game|
        User.find(game.user_id)
    end
    ftotal = freq(arrtotal)
    fwin = freq(arrwin)
    arrtotal.each do |user|
        winpercenthash[user] = fwin[user].to_f / ftotal[user] * 100
    end
    ordered_array = ftotal.sort_by {|k,v| v}.reverse
    for i in 0..ordered_array.length-1 do
        gd[ordered_array[i][0]] = winpercenthash[ordered_array[i][0]]  
    end 
    ordered_array = gd.sort_by {|k,v| v}.reverse
    if ordered_array.length == 0
        puts "There are no records to show yet!\n"
    elsif ordered_array.length < 5 && ordered_array.length > 0
        for i in 0..ordered_array.length-1 
            puts "#{ordered_array[i][0].name} won #{ordered_array[i][1].round(2)}% of their games over the course of #{ftotal[ordered_array[i][0]]} games" 
            username = ordered_array[i][0].name
            percent = ordered_array[i][1].round(2)
            numgames = ftotal[ordered_array[i][0]]
            forindex = i
            indexmax = ordered_array.length-1
            print_table(username, percent, numgames, forindex, indexmax)
        end
    else
        for i in 0..4
            username = ordered_array[i][0].name
            percent = ordered_array[i][1].round(2)
            numgames = ftotal[ordered_array[i][0]]
            forindex = i
            print_table(username, percent, numgames, forindex, 4) 
        end
    end
    puts "Press Enter to Continue..."
    gets.chomp
    system('clear')
    menu(user)
end

#creates a frequency hash Code from https://stackoverflow.com/questions/19963001/create-hash-from-array-and-frequency
def freq(array)
    hash = Hash.new(0)
    array.each{|key| hash[key] += 1}
    hash
end
# selects a random word from the library based on the difficulty level chosen by the user.  Code Credit: https://hashrocket.com/blog/posts/rails-quick-tips-random-records
def select_word(dif_lvl)
    case dif_lvl
    when 1 # easy difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 0..1000).first
    when 2 # medium difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 1001..100000).first
    when 3 # hard difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 100001..200000).first
    when 4 # super hard difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 200001..400000).first
    when 5 # master difficulty
        word = Word.limit(1).order("RANDOM()").where(difficulty: 400001..Word.maximum(:difficulty)).first
    end
end
#whenever the user stops playing prints a thanks for playing message in ascii word art
def end_program
    # ascii text from http://patorjk.com/software/taag/
    puts "
                               
  --.--|              |          
    |  |---.,---.,---.|__/ ,---. 
    |  |   |,---||   ||  \ `---. 
    `  `   '`---^`   '`   ``---' 
          ,---.                  
          |__. ,---.,---.        
          |    |   ||            
       |  `    `---'` o          
  ,---.|    ,---.,   ..,---.,---.
  |   ||    ,---||   |||   ||   |
  |---'`---'`---^`---|``   '`---|
  |              `---'      `---'
  "
    puts "Created by Philip Sterling and Karen Go \nwith Flatiron School Seattle-Web-060319\n\n\n\n\n".blue
end



# only called from when a new user is created, to tell them how to save the dino
def how_to_play(user)
    puts "Welcome, #{user.name}!\n\n".blue + "Here's a quick rundown on how to play:\n\n"
    puts "The goal of the game is to guess all letters (or the word) of the puzzle word shown in the box."
    puts "If the guess is wrong, the asteroid will get closer to your Dino!"
    puts "Type in " + "SOLVE ".blue + "to guess a word."
    puts "Type in " + "HINT ".green + "to get the hint to the puzzle word, which will be a synonym or definition of the word."
    puts "Using the HINT will advance the asteroid!"
    puts "You lose the game when the asteroid stikes the dino. :(\n\n"
    puts "Ready?\n\n\n"
end
# prints the table and formats it for the leaderboard so that it is table like and aligned
def print_table(username, percent, numgames, forindex, indexmax)
    if forindex == 0 
        percent = percent.to_s
        numgames = numgames.to_s
        i = 0
        name = ""
        line_name = ""
        percentw = ""
        line_percent = ""
        line_games = ""
        gamesw = ""
        s_username = "Username"
        s_percent = "Win %"
        s_games = "Total"
        for i in 0..10
            if s_username[i] != nil
                name << s_username[i]
            else
                name << " "
            end
            line_name << "═"
        end

        for i in 0..5
            if s_percent[i] != nil
                percentw << s_percent[i]
            else
                percentw << " "
            end
            line_percent << "═"
        end
        for i in 0..5
            if s_games[i] != nil
                gamesw << s_games[i]
            else
                gamesw << " "
            end
            line_games << "═"
        end
        puts "╔═" + line_name + "═╦═" + line_percent + "═╦═" + line_games + "═╗"
        puts "║ " + name +      " ║ " +    percentw +  " ║ " + gamesw +     " ║"
    end
    if forindex != indexmax
        percent = percent.to_s
        numgames = numgames.to_s
        i = 0
        name = ""
        line_name = ""
        percentw = ""
        line_percent = ""
        line_games = ""
        gamesw = ""
        for i in 0..10
            if username[i] != nil
                name << username[i]
            else
                name << " "
            end
            line_name << "═"
        end

        for i in 0..5
            if percent[i] != nil
                percentw << percent[i]
            else
                percentw << " "
            end
            line_percent << "═"
        end
        for i in 0..5
            if numgames[i] != nil
                gamesw << numgames[i]
            else
                gamesw << " "
            end
            line_games << "═"
        end

        puts "╠═" + line_name + "═╬═" + line_percent + "═╬═" + line_games + "═╣"
        puts "║ " + name +      " ║ " +    percentw +  " ║ " + gamesw +     " ║"
    else
        percent = percent.to_s
        numgames = numgames.to_s
        i = 0
        name = ""
        line_name = ""
        percentw = ""
        line_percent = ""
        line_games = ""
        gamesw = ""
        for i in 0..10
            if username[i] != nil
                name << username[i]
            else
                name << " "
            end
            line_name << "═"
        end

        for i in 0..5
            if percent[i] != nil
                percentw << percent[i]
            else
                percentw << " "
            end
            line_percent << "═"
        end
        for i in 0..5
            if numgames[i] != nil
                gamesw << numgames[i]
            else
                gamesw << " "
            end
            line_games << "═"
        end

        puts "╠═" + line_name + "═╬═" + line_percent + "═╬═" + line_games + "═╣"
        puts "║ " + name +      " ║ " +    percentw +  " ║ " + gamesw +     " ║"
        puts "╚═" + line_name + "═╩═" + line_percent + "═╩═" + line_games + "═╝"
        puts "\n\n\n"
    end
end