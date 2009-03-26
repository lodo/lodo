class CreateActivatables < ActiveRecord::Migration
  def self.up
    create_table :activatables do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :activatables
  end
end
