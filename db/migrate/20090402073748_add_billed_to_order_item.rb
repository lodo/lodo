class AddBilledToOrderItem < ActiveRecord::Migration
  def self.up
    add_column :order_items, :billed, :integer, :default => 0
  end

  def self.down
    remove_column :order_items, :billed
  end
end
