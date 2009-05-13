class AddLedgerIdToJournalOperation < ActiveRecord::Migration
  def self.up
    add_column :journal_operations, :ledger_id, :integer
  end

  def self.down
    remove_column :journal_operations, :ledger_id
  end
end
