class RemoveClosedFromBill < ActiveRecord::Migration
  def self.up
     remove_column :bills, :closed
   end

  def self.down
     add_column :bills, :closed, :boolean, :default => false
  end
end
