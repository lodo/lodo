class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :number, :null => false
      t.string :name, :null => false
      
      t.references :company
      
      t.boolean :active, :null => false
      t.string :lodo_name, :null => false
      t.string :debit_text, :null => false
      t.string :credit_text, :null => false
      t.string :comments, :null => false
      
      t.boolean :has_ledger, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
