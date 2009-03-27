class OrderItem < ActiveRecord::Base
  validates_numericality_of :price, :greater_than => 0.0
  validates_numericality_of :amount, :greater_than => 0.0
  
  belongs_to :product
  belongs_to :order
end
