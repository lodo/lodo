class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders
end
