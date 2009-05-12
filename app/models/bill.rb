class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders, :autosave => true
  has_one :journal, :autosave => true

  def before_save
    if self.journal.nil?
      self.journal = Journal.new(:journal_date => self.updated_at, :company => self.company)
    else
      self.journal.journal_operations.clear
    end

    self.bill_orders.each do |bill_order|
      bill_order.bill_items.each do |bill_item|
        @vat = 0
        if !bill_item.order_item.product.account.vat_account.nil?
          @vat = bill_item.order_item.product.account.vat_account.percentage
        end
        self.journal.journal_operations.push(JournalOperation.new(
          :account => bill_item.order_item.product.account,
          :amount => -bill_item.price,
          :vat => -bill_item.price * @vat,
          :vat_account => bill_item.order_item.product.account.vat_account
        ))

        if !bill_order.order.customer.account.vat_account.nil?
          @vat = bill_order.order.customer.account.vat_account.percentage
        end
        self.journal.journal_operations.push(JournalOperation.new(
          :account => bill_order.order.customer.account,
	  :amount => bill_item.price,
          :vat => bill_item.price * @vat,
          :vat_account => bill_order.order.customer.account.vat_account
        ))
      end
    end
  end

  def editable?
    return (not self.closed)
  end
end
