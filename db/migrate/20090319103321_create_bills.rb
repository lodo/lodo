class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.date :delivery_date
      t.date :billing_date
      t.references :company
      t.decimal :price, :precision => 20, :scale => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
