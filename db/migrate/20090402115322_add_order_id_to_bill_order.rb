class AddOrderIdToBillOrder < ActiveRecord::Migration
  def self.up
    add_column :bill_orders, :order_id, :integer
  end

  def self.down
    remove_column :bill_orders, :order_id
  end
end
