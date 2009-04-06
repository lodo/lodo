class VatAccount < ActiveRecord::Base
  has_many :accounts
  belongs_to :target_account, :class_name => 'Account'
end
