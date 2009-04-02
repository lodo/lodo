class Ledger < ActiveRecord::Base
  belongs_to :account
  belongs_to :activatable
  belongs_to :unit
  belongs_to :project

  validates_uniqueness_of :number, :scope => [:account_id]

end
