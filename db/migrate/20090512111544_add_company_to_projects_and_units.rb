class AddCompanyToProjectsAndUnits < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :projects, :company_id, :integer, :null => false
      add_column :units, :company_id, :integer, :null => false
    end # commit
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_column :projects, :company_id
      remove_column :units, :company_id
    end # commit
  end
end
