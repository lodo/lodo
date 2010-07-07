class CreatePaycheckLines < ActiveRecord::Migration
  def self.up
    create_table :paycheck_lines do |t|
      t.references :paycheck_line_template
      t.references :paycheck
      t.decimal :count
      t.decimal :rate
      t.decimal :amount
      t.references :unit
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :paycheck_lines
  end
end
