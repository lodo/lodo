class AddUnitIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :unit_id, :integer
  end

  def self.down
    remove_column :orders, :unit_id
  end
end
