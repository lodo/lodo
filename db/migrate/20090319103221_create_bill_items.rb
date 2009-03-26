class CreateBillItems < ActiveRecord::Migration
  def self.up
    create_table :bill_items do |t|
      t.references :order_item
      t.references :bill
      t.integer :count
      t.decimal :price, :precision => 20, :scale => 2
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :bill_items
  end
end
