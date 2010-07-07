class PaycheckLine < ActiveRecord::Base
  belongs_to :account
  belongs_to :paycheck
  belongs_to :project
  belongs_to :unit
  
  validates :line_type, :presence => true, :inclusion => {:in => PaycheckLineTemplate::TYPES.keys}
  validates :description, :presence => true
  validates :account, :presence => true, :unless => proc {line_type == PaycheckLineTemplate::TYPE_INFO}
end
