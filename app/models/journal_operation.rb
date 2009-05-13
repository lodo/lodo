class JournalOperation < ActiveRecord::Base
  belongs_to :journal
  belongs_to :account
  belongs_to :ledger
  belongs_to :vat_account
  belongs_to :unit
  belongs_to :project
  
  def debet= (num)
    self.amount = - num.to_f
  end

  def credit= (num)
    self.amount = num.to_f
  end

  def debet
    return (self.amount<0.0) ? (-self.amount) : 0.0
  end

  def credit
    return (self.amount>0.0) ? self.amount : 0.0
  end

end
