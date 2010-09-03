class CreateTaxZoneTaxes < ActiveRecord::Migration
  def self.up
    create_table :tax_zone_taxes do |t|
      t.integer :tax_zone_id
      t.decimal :tax_rate
      t.date :from

      t.timestamps
    end
  end

  def self.down
    drop_table :tax_zone_taxes
  end
end
