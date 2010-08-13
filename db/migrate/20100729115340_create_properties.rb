class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string  :key, :null => false
      t.text  :value, :null => false
      t.string  :model_name
      t.integer  :model_id
    end
    add_index :properties, [:key], {:name => 'properties_key'}
    add_index :properties, [:model_id], {:name => 'properties_model_id'}
    add_index :properties, [:key, :model_name, :model_id], {:unique => true}
  end
  
  def self.down
    drop_table :properties
  end
end
