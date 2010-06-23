class OrderItem < ActiveRecord::Base
  validates :price, :numericality => { :greater_than => 0.0 }
  validates :amount, :numericality => { :greater_than => 0.0 }
  
  belongs_to :product
  belongs_to :order
end
