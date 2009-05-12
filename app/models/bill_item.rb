class BillItem < ActiveRecord::Base
  belongs_to :bill_order
  belongs_to :order_item
end
