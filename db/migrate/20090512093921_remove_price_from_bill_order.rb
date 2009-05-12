class RemovePriceFromBillOrder < ActiveRecord::Migration
  def self.up
    remove_column :bill_orders, :price
  end

  def self.down
    add_column :bill_orders, :price, :decimal
  end
end
