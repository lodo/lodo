class AddPeriodIdToJournal < ActiveRecord::Migration
  def self.up
    add_column :journals, :period_id, :integer, :null => false
  end

  def self.down
    remove_column :journals, :period_id
  end
end
