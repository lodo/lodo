class Ledger < ActiveRecord::Base
  belongs_to :account
  belongs_to :activatable
  belongs_to :unit
  belongs_to :project
  belongs_to :address, :dependent => :destroy
  has_many :paycheck_line_templates , :foreign_key => "employee_id"

  validates :number, :uniqueness => {:scope => [:account_id]}
  accepts_nested_attributes_for :address

  def to_s
    return name
  end


end
