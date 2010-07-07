class CreatePaycheckLines < ActiveRecord::Migration
  def self.up
    create_table :paycheck_lines do |t|
      t.integer :line_type, :null=>false
      t.text :description, :null=>false    
      t.references :paycheck
      t.references :account
      t.decimal :count
      t.decimal :rate
      t.decimal :amount
      t.references :unit
      t.references :project
      t.boolean :payroll_tax, :null=>false
      t.boolean :vacation_basis, :null=>false
      t.text :salary_code, :null=>false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :paycheck_lines
  end
end
