class CreateCountyTaxZones < ActiveRecord::Migration
  def self.up
    create_table :county_tax_zones do |t|
      t.integer :county_id
      t.integer :tax_zone_id
      t.date :from

      t.timestamps
    end
  end

  def self.down
    drop_table :county_tax_zones
  end
end
