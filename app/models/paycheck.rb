class Paycheck < ActiveRecord::Base
  belongs_to :employee, :class_name => "Ledger" #, :foreign_key => "employee_id"
  belongs_to :period
  has_many :paycheck_lines
  accepts_nested_attributes_for :paycheck_lines

end