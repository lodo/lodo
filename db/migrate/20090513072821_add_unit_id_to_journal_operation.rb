class AddUnitIdToJournalOperation < ActiveRecord::Migration
  def self.up
    add_column :journal_operations, :unit_id, :integer
  end

  def self.down
    remove_column :journal_operations, :unit_id
  end
end
