class Company < ActiveRecord::Base
  belongs_to :users
  belongs_to :accounts
  belongs_to :address
end
