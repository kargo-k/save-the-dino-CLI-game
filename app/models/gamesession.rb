class GameSession < ActiveRecord::Base
    has_many :words
    has_many :users

    def start_game(user_obj, dif_lvl)
        word = select_word(dif_lvl)
        GameSession.create(user_id: user_obj.id, word_id: word.id)
    end

    # selects a random word from the library based on the difficulty level chosen by the user.  Code Credit: https://hashrocket.com/blog/posts/rails-quick-tips-random-records
    def select_word(dif_lvl)
        case dif_lvl
        when 1 # easy difficulty
            word = Word.limit(1).order("RANDOM()").where(difficulty: 0..1000)
        when 2 # medium difficulty
            word = Word.limit(1).order("RANDOM()").where(difficulty: 1001..100000)
        when 3 # hard difficulty
            word = Word.limit(1).order("RANDOM()").where(difficulty: 100001..200000)
        when 4 # super hard difficulty
            word = Word.limit(1).order("RANDOM()").where(difficulty: 200001..400000)
        when 5 # master difficulty
            word = Word.limit(1).order("RANDOM()").where(difficulty: 400001..Word.maximum(:difficulty))
        end
    end

end