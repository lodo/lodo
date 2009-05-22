class RemoveMvaFromOrder < ActiveRecord::Migration
  def self.up
     remove_column :orders, :mva
   end

  def self.down
     add_column :orders, :mva, :integer
   end
end
