class IndexJournalData < ActiveRecord::Migration
  def self.up
    add_index :journal_operations, :journal_id
    add_index :journals, :company_id
  end

  def self.down
    remove_column :journal_operations, :company_id
    remove_index "index_journals_on_company_id"
  end
end
