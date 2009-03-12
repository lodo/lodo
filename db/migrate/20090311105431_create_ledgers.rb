class CreateLedgers < ActiveRecord::Migration
  def self.up
    create_table :ledgers do |t|
      t.string :name, :null => false
      t.references :account, :null => false
      t.integer :number, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :ledgers
  end
end
