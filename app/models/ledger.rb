class Ledger < ActiveRecord::Base
  belongs_to :account
  belongs_to :activatable
  belongs_to :unit
  belongs_to :project
  belongs_to :address, :dependent => :destroy

  validates :number, :uniqueness => {:scope => [:account_id]}
  accepts_nested_attributes_for :address

end
