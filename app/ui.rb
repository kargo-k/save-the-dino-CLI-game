def welcome
    puts "Hey, thanks for hanging my man."
    puts "ahhhhhhhhhhhhh"
end
def getplayername
    puts "Enter your username:"
    puts "Type EXIT to exit:"
    name = gets.chomp
    if name.downcase == "exit"
        end_program
        return nil
    elsif User.all.any? { |user| user.name.downcase == name.downcase }
        User.all.select { |user| user.name.downcase == name.downcase}[0]
    else
        User.create(name: name)
    end
end 

def menu(user)
    if user == nil
        return nil
    end
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
            view_leaderboard(user)
            break
        when 3
            user.update_username
            break
        when 4
            user.delete_user
            end_program
            break
        when 5
            end_program
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

def view_leaderboard(user)
    winpercenthash = {}
    i = 0
    arrtotal = GameSession.all.map do |game|
        User.find(game.user_id)
    end
    arrwin = GameSession.all.select do |game|
        game.win == true
    end
    arrwin.map! do |game|
        User.find(game.user_id)
    end
    ftotal = freq(arrtotal)
    fwin = freq(arrwin)
    arrtotal.map do |user|
        winpercenthash[user] = fwin[user].to_f / ftotal[user] * 100
    end
    ordered_array = winpercenthash.sort_by {|k,v| v}.reverse
    if ordered_array.length < 5
        for i in 0..ordered_array.length-1 
            puts "#{ordered_array[i][0].name} won #{ordered_array[i][1]}% of their games over the course of #{ftotal[ordered_array[i][0]]} games" 
        end
    end
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
def end_program
    puts "Thanks for playing!"
end
def delete_user(user)
    GameSession.all.each do |game|
        if game.user_id == user.id
            game.destroy
        end
    end
    user.destroy
end