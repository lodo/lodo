class Account < ActiveRecord::Base
  has_many :ledgers, :dependent => :destroy, :order => "lower(name)"
  has_many :products
  belongs_to :company
  belongs_to :activatable
  belongs_to :vat_account

  def vat_description
    if self.vat_account
      if self.vat_account.target_account
        return self.vat_account.target_account.name
      end
      return "has vat, but invalid"
    end
    return "none"
  end

  def description
    sprintf('%.4d', self.number) + " " + self.name
  end

  def to_s
    return description
  end

  
end
