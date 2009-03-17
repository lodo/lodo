class Account < ActiveRecord::Base
  has_many :ledgers, :dependent => :destroy
  belongs_to :companies
end
