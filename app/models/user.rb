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
        puts "Type " + "DELETE".red.underline + " if you are sure you want to delete #{self.name}?"
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
            puts "Your username has been deleted."
            end_program
        else
            menu(self)
        end
    end

    # this method lists the words that a specific user has played
    def list_my_words
        games = GameSession.where(user_id: self.id)
        games = games.select {|game| game.word_id != nil}
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
    #prints a table showing only the user that is passed in and their stats
    def self_records

        arrselftotal = GameSession.all.select do |game|
            game.user_id == self.id
        end
        arrselftotal = arrselftotal.select do |game|
            game.word_id != nil
        end
        arrselfwin = arrselftotal.select do |game| 
            game.win == true
        end
        percent = arrselfwin.length.to_f/arrselftotal.length * 100
        if arrselftotal.length > 0
            username = self.name
            percent = percent.round(2)
            numgames = arrselftotal.length
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
            s_name = ""
            s_percentw = ""
            s_gamesw = ""
            for i in 0..10
                if s_username[i] != nil
                    s_name << s_username[i]
                else
                    s_name << " "
                end
                if username[i] != nil
                    name << username[i]
                else
                    name << " "
                end
                line_name << "═"
            end
    
            for i in 0..5
                if s_percent[i] != nil
                    s_percentw << s_percent[i]
                else
                    s_percentw << " "
                end
                if percent[i] != nil
                    percentw << percent[i]
                else
                    percentw << " "
                end
                line_percent << "═"
            end
            for i in 0..5
                if s_games[i] != nil
                    s_gamesw << s_games[i]
                else
                    s_gamesw << " "
                end
                if numgames[i] != nil
                    gamesw << numgames[i]
                else
                    gamesw << " "
                end
                line_games << "═"
            end
            puts "╔═" + line_name + "═╦═" + line_percent + "═╦═" + line_games + "═╗"
            puts "║ " + s_name +      " ║ " +    s_percentw +  " ║ " + s_gamesw +     " ║"
            puts "╠═" + line_name + "═╬═" + line_percent + "═╬═" + line_games + "═╣"
            puts "║ " + name +      " ║ " +    percentw +  " ║ " + gamesw +     " ║"
            puts "╚═" + line_name + "═╩═" + line_percent + "═╩═" + line_games + "═╝"
            puts "\n\n\n"
        else
            puts "#{self.name} has not played any games!\n\n\n"
        end
        self.list_my_words
        puts "Press Enter to Continue..."
        gets.chomp
        system('clear')
        menu(self)
    end
end