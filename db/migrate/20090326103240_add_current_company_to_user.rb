class AddCurrentCompanyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :current_company, :integer
  end

  def self.down
    remove_column :users, :current_company
  end
end
