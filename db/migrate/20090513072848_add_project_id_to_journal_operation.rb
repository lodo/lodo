class AddProjectIdToJournalOperation < ActiveRecord::Migration
  def self.up
    add_column :journal_operations, :project_id, :integer
  end

  def self.down
    remove_column :journal_operations, :project_id
  end
end
