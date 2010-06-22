class CreateTaxRates < ActiveRecord::Migration
  def self.up
    create_table :tax_rates do |t|
      t.integer :year
      t.string :table_name, :limit => 4
      t.integer :period_length
      t.integer :tax_type
      t.integer :gross_amount
      t.integer :tax_amount

      t.timestamps
    end
    add_index :tax_rates, [:table_name, :gross_amount, :year, :period_length, :tax_type], :unique => true, :name => :tax_rate_index
  end

  def self.down
    drop_table :tax_rates
  end
end
