class RenameUserCurrentCompanyColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :current_company, :current_company_id
  end

  def self.down
    rename_column :users, :current_company_id, :current_company
  end
end
