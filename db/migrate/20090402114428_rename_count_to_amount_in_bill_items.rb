class RenameCountToAmountInBillItems < ActiveRecord::Migration
  def self.up
    rename_column :bill_items, :count, :amount
  end

  def self.down
    rename_column :bill_items, :amount, :count
  end
end
