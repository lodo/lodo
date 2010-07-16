class AddCompanyToPaycheckLineTemplates < ActiveRecord::Migration
  
  def self.up
    add_column :paycheck_line_templates, :company_id, :integer
  end
  
  def self.down
    remove_column :paycheck_line_templates, :company_id
  end
  
end
