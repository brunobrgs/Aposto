class AddCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
