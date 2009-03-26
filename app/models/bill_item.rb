class BillItem < ActiveRecord::Base
  belongs_to :order_item
end
