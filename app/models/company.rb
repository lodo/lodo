class Company < ActiveRecord::Base
  has_many :accounts, :order => :number
  has_many :orders
  has_many :bills
  has_many :vat_accounts
  belongs_to :address

  has_many :assignments, :include => [:role, :user]
  accepts_nested_attributes_for :assignments, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs["user_id"].blank? || attrs["role_id"].blank?}

  has_many :users, :through => :assignments, :order => "users.email"
  has_many :projects, :order => "lower(name)"
  has_many :units, :order => "lower(name)"
  has_many :periods
  has_many :journals

  # hmm.. no idea what validations make sense atm
  #validates :organization_number, :format => {:with => /^(NO|no)?[\d]{9,}(MVA|mva)?$/}

  def last_period
    return (self.periods.sort { |a,b| a.year != b.year ? a.year <=> b.year : a.nr <=> b.nr })[-1]
  end
end
