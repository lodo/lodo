class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.decimal :price, :precision => 20, :scale => 2
      t.integer :mva
      t.date :order_date
      t.date :requested_delivery_date
      t.references :seller
      t.references :customer
      t.references :delivery_address
      t.references :transport
      t.references :company
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
