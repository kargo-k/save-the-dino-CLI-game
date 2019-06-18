class CreateWordsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string  :word
      t.integer :difficulty
    end
  end
end
