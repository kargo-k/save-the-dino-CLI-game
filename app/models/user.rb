class User < ActiveRecord::Base
    belongs_to :gamesession
    #Updates the user that calls this methods name to the new input unless that input is exit
    def update_username
        puts "Choose your new name: "
        puts "To return to menu, enter EXIT.\n\n"
        print ">> "

        newname = gets.chomp
        if newname.downcase == "exit"
            menu(self)
        else
            self.name = newname
            self.save
            menu(self)
        end
    end
    # removes the user that called the method and all of their gamesession data from the database if they confirm with the delete keyword
    def delete_user
        system('clear')
        puts "Type DELETE if you are sure you want to delete #{self.name}?"
        puts "User any other input to return to menu\n\n"
        print ">> "
        confirm = gets.chomp
        system('clear')
        if confirm.downcase == "delete"
            GameSession.all.each do |game|
                if game.user_id == self.id
                   game.destroy
                end
            end
            self.destroy
            end_program
        else
            menu(self)
        end
    end

    # this method lists the words that a specific user has played
    def list_my_words
        games = GameSession.where(user_id: self.id)
        words = games.map {|gs| Word.find(gs.word_id).word}
        wins = games.map {|gs| gs.win}
        h = {true => [], false => []}
        for i in 0..words.length-1
            wins[i] ? h[true] << words[i].green : h[false] << words[i].red
        end
        puts "Puzzles Won".green.underline
        puts h[true]
        puts "\n"
        puts "Puzzles Lost".red.underline
        puts h[false]
        puts "\n\n\n"
    end
end