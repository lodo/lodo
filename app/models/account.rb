class Account < ActiveRecord::Base
  has_many :ledgers, :dependent => :destroy
end
