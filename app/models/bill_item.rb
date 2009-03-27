class BillItem < ActiveRecord::Base
  belongs_to :bill_order
end
