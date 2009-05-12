class RemovePriceFromBill < ActiveRecord::Migration
  def self.up
    remove_column :bills, :price
  end

  def self.down
    add_column :bills, :price, :decimal
  end
end
