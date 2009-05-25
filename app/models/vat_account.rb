class VatAccount < ActiveRecord::Base
  has_many :accounts
  belongs_to :company
  belongs_to :target_account, :class_name => 'Account'
  has_many :vat_account_periods

  def vat_account_period_from_date(date)
    (self.vat_account_periods.find_all do |vat_account_period|
      vat_account_period.valid_from <= self.journal.journal_date
     end
    ).min do |a, b|
      a.valid_from <=> b.valid_from
    end
  end
end
