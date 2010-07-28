class ChangePaycheckLineTemplates < ActiveRecord::Migration
  def self.up
    change_column :paycheck_line_templates, :employee_id, :integer, :null => true
    change_column :paycheck_line_templates, :company_id, :integer, :null => false
  end

  def self.down
    change_column :paycheck_line_templates, :employee_id, :integer, :null => false
    change_column :paycheck_line_templates, :company_id, :integer, :null => true
  end
end
