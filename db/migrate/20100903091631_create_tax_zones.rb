class CreateTaxZones < ActiveRecord::Migration
  def self.up
    create_table :tax_zones do |t|
      t.integer :number
      t.timestamps
    end
  end

  def self.down
    drop_table :tax_zones
  end
end
