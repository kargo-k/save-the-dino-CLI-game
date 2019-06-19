class User < ActiveRecord::Base
    belongs_to :gamesession

    def update_username
        puts "Choose your new name: "
        prints ">> "
        newname = gets.chomp
        self.name = newname
        self.save
        menu(self)
    end
    
    def delete_user
        GameSession.all.each do |game|
            if game.user_id == self.id
                game.destroy
            end
        end
        self.destroy
    end
end