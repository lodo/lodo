class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.integer :type
      t.integer :number
      t.date :journal_date

      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end
