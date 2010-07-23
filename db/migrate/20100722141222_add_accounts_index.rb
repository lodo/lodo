class AddAccountsIndex < ActiveRecord::Migration
  def self.up
    add_index 'accounts',['company_id'], {:name => 'accounts_company_idx'}
  end

  def self.down
    remove_index 'accounts', 'accounts_company_idx'
  end
end
