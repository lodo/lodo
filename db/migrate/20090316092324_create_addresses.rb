class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :name
      t.string :street1
      t.string :street2
      t.string :postal_code
      t.string :town
      t.string :country

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
