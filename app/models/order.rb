class Order < ActiveRecord::Base
  belongs_to :seller
  belongs_to :customer
  belongs_to :delivery_address
  belongs_to :transport
  belongs_to :company
  has_many :order_items

  def discount
    100.0 * (1.0-self.price / self.order_items.inject(0.0){|sum,item| sum+item.price})
  end

end
