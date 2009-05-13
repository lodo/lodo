class AddPeriodIdToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :period_id, :integer
  end

  def self.down
    remove_column :bills, :period_id
  end
end
