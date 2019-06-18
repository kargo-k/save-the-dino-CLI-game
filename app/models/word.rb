class Word < ActiveRecord::Base
    belongs_to :gamesession

# This method initializes the word library by using the lib/words.txt files and collects the list of words and their frequency of use and stores it into the words table in the hangman database.  This selectively stores words that are longer than 5 and calculates a difficulty by dividing the length of the word by the word's frequency of use.
    def self.initialize_library
        f = File.open('./lib/words.txt')
        f.each do |line|
            x = line.split
            word = x[0][1..-2]
            freq = x[1][0..-2].to_f
            if word.length > 5
                w = Word.create(
                    word: word, 
                    difficulty: word.length/freq)
            end
        end
    end
end