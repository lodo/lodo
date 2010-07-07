class CreatePaycheckLineTemplates < ActiveRecord::Migration
  def self.up
    create_table :paycheck_line_templates do |t|
      t.integer :line_type, :null=>false
      t.text :description, :null=>false
      t.decimal :count, :null=>false
      t.decimal :rate, :null=>false
      t.decimal :amount, :null=>false
      t.references :account
      t.references :unit
      t.references :project
      t.boolean :payroll_tax, :null=>false
      t.boolean :vacation_basis, :null=>false
      t.text :salary_code, :null=>false
      t.references :employee, :null=>false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :paycheck_line_templates
  end
end
