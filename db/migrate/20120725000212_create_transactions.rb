class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, :null => false
      t.decimal :value, :null => false, :precision => 8, :scale => 2
      t.string :ident, :null => false, :limit => 2
      t.integer :related_id
      t.string :related_type

      t.timestamps
    end
    add_index :transactions, :user_id
    add_index :transactions, :ident
  end
end
