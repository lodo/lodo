class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.integer :journal_type
      t.integer :number
      t.date :journal_date
      t.references :company

      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end
