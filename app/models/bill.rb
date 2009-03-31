class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders

  def discount
    if self.price.nil?
      0
    else
      100.0 * (1.0-self.price / self.bill_orders.inject(0.0){|sum,item| sum+item.price})
    end
  end

end
