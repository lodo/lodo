class AddBillIdToJournal < ActiveRecord::Migration
  def self.up
    add_column :journals, :bill_id, :integer
  end

  def self.down
    remove_column :journals, :bill_id
  end
end
