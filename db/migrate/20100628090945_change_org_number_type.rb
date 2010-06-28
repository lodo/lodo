class ChangeOrgNumberType < ActiveRecord::Migration
  def self.up
    change_column :companies, :organization_number, :string, :null => true
  end

  def self.down
    change_column :companies, :organization_number, :integer, :null => true
  end
end
