class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders, :autosave => true
  has_one :journal

  def save
=begin
    if self.journal.nil?

    else
      self.journal.journal_operations.each { |o| o.destroy }
    end

    self.bill_orders.each begin |bill_order|
      bill_order.bill_items.each begin |bill_item|

      end
    end
    

=end
    super
  end

  def editable?
    return (not self.closed)
  end
end
