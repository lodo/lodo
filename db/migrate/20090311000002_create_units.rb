class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string :name, :null => false
      t.references :address
      t.string :comments
      t.timestamps
    end
  end

  def self.down
    drop_table :units
  end
end
