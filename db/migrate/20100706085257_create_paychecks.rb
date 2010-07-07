class CreatePaychecks < ActiveRecord::Migration
  def self.up
    create_table :paychecks do |t|
      t.references :period
      t.references :employee

      t.timestamps
    end
  end

  def self.down
    drop_table :paychecks
  end
end
