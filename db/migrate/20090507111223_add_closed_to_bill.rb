class AddClosedToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :closed
  end
end
