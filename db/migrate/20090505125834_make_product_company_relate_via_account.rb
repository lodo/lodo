class MakeProductCompanyRelateViaAccount < ActiveRecord::Migration
  def self.up
    add_column :products, :account_id, :integer
    remove_column :products, :company_id
  end

  def self.down
    remove_column :products, :account_id
    add_column :products, :company_id, :integer
  end
end
