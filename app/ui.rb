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
            puts "would have started with #{difstr_arr[intdif-1]}"
            #start_game(user, intdif)
            break
        else
            puts "Error, #{input} is not 1-5, try again"
            input = gets.chomp
        end
    end
end
def view_leaderboard 
    GameSession.all
    binding.pry
end