class CreateJournalOperations < ActiveRecord::Migration
  def self.up
    create_table :journal_operations do |t|
      t.references :journal
      t.references :account
      t.decimal :amount, :precision => 20, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :journal_operations
  end
end
