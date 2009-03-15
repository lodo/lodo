class Company < ActiveRecord::Base
  belongs_to :users
  belongs_to :accounts
  belongs_to :address

  has_and_belongs_to_many :users
end
