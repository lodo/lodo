class BillOrder < ActiveRecord::Base
  belongs_to :bill
  has_many :bill_items
  has_one :order
end
