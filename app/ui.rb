def welcome
    puts "Hey, thanks for hanging my man."
    puts "ahhhhhhhhhhhhh"
end
def getplayername
    puts "Enter your username:"
    name = gets.chomp
    if User.all.any? { |user| user.name.downcase == name.downcase }
        User.all.select { |user| user.name.downcase == name.downcase}[0]
    else
        User.create(name: name)
    end
end 

def menu(user)
    puts "Make your selection (1-5):"
    puts "1. Start New Game"
    puts "2. View Leaderboard"
    puts "3. Change your Username"
    puts "4. Delete your Username and Exit"
    puts "5. Exit"
    input = gets.chomp

    loop do
        case input.to_i
        when 1
            select_difficulty(user)
            break
        when 2
            view_leaderboard
            break
        when 3
            puts "update username"
            break
        when 4
            puts "delete user profile"
            break
        when 5
            puts "Thanks for playing!"
            break
        else
            puts "Error, #{input} is not 1-5, try again"
            input = gets.chomp
        end
    end
end

# Prompts the user to select a difficulty level between 1-5
def select_difficulty(user)
    puts "Make your selection (1-5):"
    difstr_arr = ["Easy","Medium","Hard","Expert","Master"]
    puts "1. #{difstr_arr[0]}"
    puts "2. #{difstr_arr[1]}"
    puts "3. #{difstr_arr[2]}"
    puts "4. #{difstr_arr[3]}"
    puts "5. #{difstr_arr[4]}"
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

def view_leaderboard 
    GameSession.all
    binding.pry
end