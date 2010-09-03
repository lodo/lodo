class AddPaycheckLineTemplateCheckbox < ActiveRecord::Migration
  def self.up
    add_column :paycheck_line_templates, :use, :boolean
  end

  def self.down
    remove_column :paycheck_line_templates, :use
  end
end
