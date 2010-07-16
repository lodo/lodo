class PaycheckLineTemplate < ActiveRecord::Base
  TYPE_INCOME = 0
  TYPE_EXPENSE = 1
  TYPE_INFO = 2
  
  TYPES = {
    TYPE_INCOME => I18n.t('paycheck_line_templates.income'),
    TYPE_EXPENSE => I18n.t('paycheck_line_templates.expense'),
    TYPE_INFO => I18n.t('paycheck_line_templates.info'),
  }
  
  belongs_to :employee, :class_name => "Ledger"
  belongs_to :project
  belongs_to :unit
  belongs_to :account
  belongs_to :company
  
  validates :line_type, :presence => true, :inclusion => {:in => TYPES.keys}
  validates :description, :presence => true
  validates :account, :presence => true, :unless => proc {line_type == TYPE_INFO}
  #validates :payroll_tax, :presence => true
  #validates :vacation_basis, :presence => true
  
  def maybe_employee_id
    employee ? employee.id : "global"
  end
end
