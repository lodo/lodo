class AddPaycheckJournal < ActiveRecord::Migration
  def self.up
    add_column :paychecks, :journal_id, :integer
    add_index :paychecks, :journal_id, {:name => 'paychecks_journal_idx'}
  end
  
  def self.down
    remove_column :paychecks, :journal_id
    remove_index 'paychecks', 'paychecks_journal_idx'
  end
end
