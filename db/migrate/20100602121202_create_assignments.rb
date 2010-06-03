class CreateAssignments < ActiveRecord::Migration
  def self.up
    drop_table :companies_users
    create_table :assignments do |t|
      t.references :role, :null => false
      t.references :user, :null => false
      t.references :company, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
    create_table :companies_users do |t|
      t.references :user
      t.references :company
    end
  end
end
