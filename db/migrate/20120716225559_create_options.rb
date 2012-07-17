class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :challenge, :null => false
      t.string :answer, :null => false
      t.timestamps
    end
    add_index :options, :challenge_id
  end
end
