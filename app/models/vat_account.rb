class VatAccount < ActiveRecord::Base
  has_many :accounts
  belongs_to :company
  belongs_to :target_account, :class_name => 'Account'
  has_many :vat_account_periods
end
