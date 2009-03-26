class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.decimal :price, :precision => 20, :scale => 2
      t.string :name
      t.references :company
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
