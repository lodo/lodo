class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.references :product
      t.references :order
      t.decimal :price, :precision => 20, :scale => 2
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
