class GameSession < ActiveRecord::Base
    has_many :words
    has_many :users

    def start_game
        binding.pry
        self
    end

end