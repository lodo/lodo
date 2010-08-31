class AddLedgerInfo < ActiveRecord::Migration
  def self.up
    add_column :ledgers, :id_number, :string
    add_column :ledgers, :county_period, :integer
    add_column :ledgers, :work_percentage, :integer
    add_column :ledgers, :work_start, :date
    add_column :ledgers, :work_stop, :date
  end
  
  def self.down
    remove_column :ledgers, :id_number
    remove_column :ledgers, :county_period
    remove_column :ledgers, :work_percentage
    remove_column :ledgers, :work_start
    remove_column :ledgers, :work_stop
  end
end
