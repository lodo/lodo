class Order < ActiveRecord::Base
  belongs_to :seller
  belongs_to :customer
  belongs_to :delivery_address
  belongs_to :transport
  belongs_to :company
  has_many :order_items
end
