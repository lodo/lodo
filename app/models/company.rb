class Company < ActiveRecord::Base
  has_many :accounts
  belongs_to :address
  has_and_belongs_to_many :users
  
end
