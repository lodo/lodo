class Paycheck < ActiveRecord::Base
  belongs_to :employee, :class_name => "Ledger" #, :foreign_key => "employee_id"
  belongs_to :period
  belongs_to :paycheck_period
  belongs_to :journal
  has_many :paycheck_lines
  accepts_nested_attributes_for :paycheck_lines
  
  
  
end
