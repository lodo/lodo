class AddMiscIndices < ActiveRecord::Migration
  def self.up
    add_index :periods, :company_id, {:name => 'periods_company_idx'}
    add_index :journals, :period_id, {:name => 'journals_period_idx'}
    add_index :bills, :period_id, {:name => 'bills_period_idx'}
    add_index :bills, :company_id, {:name => 'bills_company_idx'}

    add_index :journals, [:company_id, :number, :journal_type], {:name => 'journals_misc_idx'}
    execute "cluster journals_misc_idx on journals"

    execute "create index journals_bill_idx on journals (bill_id) where bill_id is not null;"
  end

  def self.down
    remove_index 'periods', 'periods_company_idx'
    remove_index 'journals', 'journals_period_idx'
    remove_index 'bills', 'bills_period_idx'
    remove_index 'bills', 'bills_company_idx'

    remove_index 'journals', 'journals_misc_idx'

    execute "drop index journals_bill_idx"
  end
end
