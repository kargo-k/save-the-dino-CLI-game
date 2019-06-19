word = "peanutbutter"
tries = 6
puzzle = ""
line = ""
for i in 1..word.length
    puzzle << "_ "
    line << "══"
end
puts "╔═" + line + "═╗"
puts "║ " + puzzle + " ║"
puts "╚═" + line + "═╝"

flag = false
while flag == false && tries > 0 && puzzle.include?("_")
puts "\n\nTo exit the game, enter EXIT\nTo guess a letter, enter a letter.\n#{tries} tries remaining.\n\n"
    guess = gets.chomp
    if guess.upcase == "EXIT"
        # ! exit game function here
        # ! self.win = false
        flag = true
    elsif guess.length == 1 && "abcdefghijklmnopqrstuvwxyz".include?(guess.downcase)
        if word.include?(guess)
            for i in 1..word.count(guess)
                puzzle[word.index(guess)*2] = guess
                word[word.index(guess)] = "_"
            end
            puts "╔═" + line + "═╗"
            puts "║ " + puzzle + " ║"
            puts "╚═" + line + "═╝"
        else
            tries -= 1
            puts "Sorry, #{guess} is not in the word."
            puts "╔═" + line + "═╗"
            puts "║ " + puzzle + " ║"
            puts "╚═" + line + "═╝"
        end
    else
        puts "Invalid input!  Please try again.\n\n\n"
        puts "╔═" + line + "═╗"
        puts "║ " + puzzle + " ║"
        puts "╚═" + line + "═╝"
    end
end

if tries == 0
    # self.win = false
elsif !puzzle.include?("_")
    # self.win = true
    puts "\n\nYou solved the puzzle!\n\n"
    menu
end