class CreatePeriods < ActiveRecord::Migration
  def self.up
    create_table :periods do |t|
      t.integer :year
      t.integer :nr
      t.integer :status
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :periods
  end
end
