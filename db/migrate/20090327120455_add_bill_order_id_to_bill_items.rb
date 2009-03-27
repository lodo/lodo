class AddBillOrderIdToBillItems < ActiveRecord::Migration
  def self.up
    add_column :bill_items, :bill_order_id, :integer
    remove_column :bill_items, :bill_id
  end

  def self.down
    add_column :bill_items, :bill_id, :integer
    remove_column :bill_items, :bill_order_id
  end
end
