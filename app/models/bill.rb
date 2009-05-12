class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders
  has_one :journal

  def discount
    if self.price.nil?
      0
    else
      100.0 * (1.0-self.price / self.bill_orders.inject(0.0){|sum,item| sum+item.price})
    end
  end

  def save
    if self.journal.nil?

    else
      self.journal.journal_operations.each { |o| o.destroy }
    end

    self.bill_orders.each begin |bill_order|
      bill_order.bill_items.each begin |bill_item|

      end
    end
    


    super
  end

  def editable?
    return (not self.closed)
  end
end
