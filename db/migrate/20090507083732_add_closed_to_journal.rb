class AddClosedToJournal < ActiveRecord::Migration
  def self.up
    add_column :journals, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :journals, :closed
  end
end
