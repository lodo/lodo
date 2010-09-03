class AddPaycheckLineTemplateId < ActiveRecord::Migration
  def self.up
    add_column :paycheck_lines, :paycheck_line_template_id, :integer
  end
  
  def self.down
    remove_column :paycheck_lines, :paycheck_line_template_id
  end
end
