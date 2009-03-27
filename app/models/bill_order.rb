class BillOrder < ActiveRecord::Base
  belongs_to :bill
  has_many :bill_items
end
