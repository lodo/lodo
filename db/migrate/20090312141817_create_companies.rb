class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.integer :organization_number
      t.references :address
      
      t.timestamps
    end
    
    create_table :companies_users, :id => false do |t|
      t.references :company
      t.references :user
    end
  end

  def self.down
    drop_table :companies
  end
end
