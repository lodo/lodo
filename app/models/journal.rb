class Journal < ActiveRecord::Base
  has_many :journal_operation
  has_one :company
  belongs_to :bill

  def editable?
    return (not self.closed and self.bill_id.nil?)
  end
end
