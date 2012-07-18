class AddSlugToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :slug, :string, :after => :user_id
    add_index :challenges, :slug, unique: true
  end
end
