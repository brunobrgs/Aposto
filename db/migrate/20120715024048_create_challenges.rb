class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :user_id, :null => false
      t.string :question, :null => false
      t.boolean :private, :default => false
      t.decimal :bet_value, :null => false, :precision => 8, :scale => 2
      t.integer :max_bets, :null => false
      t.date :start_date
      t.date :end_date, :null => false
      t.integer :correct_option
      t.timestamps
    end
  end
end
