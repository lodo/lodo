class Journal < ActiveRecord::Base
  has_many :journal_operation
  belongs_to :company
  belongs_to :bill

  def editable?
    return (not self.closed and self.bill_id.nil?)
  end
end
