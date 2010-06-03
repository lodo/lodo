class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable
      t.integer :current_company_id, :null => true

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
    create_table(:users) do |t|
      t.string :login, :null => false
      t.string :hashed_password
      t.string :email
      t.string salt
      t.integer current_company_id

      t.timestamps
    end
  end
end
