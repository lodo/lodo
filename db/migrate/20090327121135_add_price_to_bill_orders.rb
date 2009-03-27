class AddPriceToBillOrders < ActiveRecord::Migration
  def self.up
    add_column :bill_orders, :price, :decimal
  end

  def self.down
    remove_column :bill_orders, :price
  end
end
