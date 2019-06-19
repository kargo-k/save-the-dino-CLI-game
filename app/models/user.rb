class User < ActiveRecord::Base
    belongs_to :gamesession

    def update_username
        puts "Choose your new name: "
        puts "EXIT to return to menu:\n\n"
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
end