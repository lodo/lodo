class CreateVatAccounts < ActiveRecord::Migration
  def self.up
    create_table :vat_accounts do |t|
      t.references :target_account
      t.integer :percentage
      t.boolean :overridable
      t.integer :code
      t.date :valid_from
      t.date :valid_to
      t.references :company

      t.timestamps
    end
  end

  def self.down
    drop_table :vat_accounts
  end
end
