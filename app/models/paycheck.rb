class Paycheck < ActiveRecord::Base
  belongs_to :employee, :class_name => "Ledger"
  belongs_to :period
end
