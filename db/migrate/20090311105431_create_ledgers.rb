class CreateLedgers < ActiveRecord::Migration
  def self.up
    create_table :ledgers do |t|
      t.string :name, :null => false
      t.references :account, :null => false
      t.integer :number, :null => false
      t.references :account_type
      t.references :address
      t.string :telephone_number
      t.string :mobile_number
      t.string :email
      t.string :comment
      t.boolean :placement_top 
      t.string :customer_number 
      t.string :ledger_bank_number
      t.string :foreign_bank_number
      t.string :debit_text, :null => false
      t.string :credit_text, :null => false
      t.references :unit
      t.references :project
      t.integer :credit_days
      t.boolean :auto_payment
      t.boolean :net_bank
      t.references :result_account

      t.timestamps
    end
  end

  def self.down
    drop_table :ledgers
  end
end
