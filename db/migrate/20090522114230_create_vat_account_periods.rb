class CreateVatAccountPeriods < ActiveRecord::Migration
  def self.up
    create_table :vat_account_periods do |t|
      t.integer :vat_account_id
      t.integer :percentage
      t.date :valid_from

      t.timestamps
    end

    remove_column :vat_accounts, :percentage
    remove_column :vat_accounts, :valid_from
    remove_column :vat_accounts, :valid_to
    remove_column :vat_accounts, :code
  end

  def self.down
    add_column :vat_accounts, :percentage, :integer
    add_column :vat_accounts, :valid_from, :date
    add_column :vat_accounts, :valid_to, :date
    add_column :vat_accounts, :code, :integer

    drop_table :vat_account_periods
  end
end
