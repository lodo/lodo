class PaycheckLine < ActiveRecord::Base
  belongs_to :paycheck_line_template
  belongs_to :paycheck
  belongs_to :project
  belongs_to :unit

end
