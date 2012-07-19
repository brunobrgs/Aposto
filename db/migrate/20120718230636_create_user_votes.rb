class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.references :user, :null => false
      t.references :option, :null => false
      t.timestamps
    end
    add_index :user_votes, :user_id
    add_index :user_votes, :option_id
  end
end
