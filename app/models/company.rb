class Company < ActiveRecord::Base
  has_many :accounts
  has_many :products
  has_many :orders
  has_many :bills
  belongs_to :address
  has_and_belongs_to_many :users
  
end
