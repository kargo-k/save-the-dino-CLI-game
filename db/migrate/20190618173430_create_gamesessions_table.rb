class CreateGamesessionsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :game_sessions do |t|
      t.integer :user_id
      t.integer :word_id
      t.boolean :win
    end
  end
end
