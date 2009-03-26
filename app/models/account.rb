class Account < ActiveRecord::Base
  has_many :ledgers, :dependent => :destroy
  belongs_to :companies
  belongs_to :activatable
end
