class Company < ActiveRecord::Base
  has_many :accounts
  has_many :orders
  has_many :bills
  has_many :vat_accounts
  belongs_to :address
  has_and_belongs_to_many :users
  
end
