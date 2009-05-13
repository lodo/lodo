class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :bill_orders, :autosave => true
  has_one :journal, :autosave => true

  def after_save
    if self.journal.nil?
      self.journal = Journal.new(:journal_date => self.updated_at, :company => self.company)
    else
      self.journal.journal_operations.clear
      self.journal.journal_date = self.updated_at
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
          :unit => bill_order.order.unit,
          :project => bill_order.order.project,
          :vat => -bill_item.price * @vat,
          :vat_account => bill_item.order_item.product.account.vat_account
        ))

        if !bill_order.order.customer.account.vat_account.nil?
          @vat = bill_order.order.customer.account.vat_account.percentage
        end
        self.journal.journal_operations.push(JournalOperation.new(
          :account => bill_order.order.customer.account,
          :ledger => bill_order.order.customer,
          :unit => bill_order.order.customer.unit,
          :project => bill_order.order.customer.project,
	  :amount => bill_item.price,
          :vat => bill_item.price * @vat,
          :vat_account => bill_order.order.customer.account.vat_account
        ))
      end
    end
    self.journal.save
  end

  def editable?
    return (not self.journal.nil? or not self.journal.closed)
  end
end
