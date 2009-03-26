class CreateActivePeriods < ActiveRecord::Migration
  def self.up
    create_table :active_periods do |t|
      t.integer :start
      t.integer :stop
      t.references :activatable

      t.timestamps
    end
  end

  def self.down
    drop_table :active_periods
  end
end
