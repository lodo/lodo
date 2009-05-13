class Journal < ActiveRecord::Base
  has_many :journal_operations, :autosave => true
  belongs_to :company
  belongs_to :bill
  belongs_to :period

  def editable?
    return (not self.closed and self.bill_id.nil?)
  end
end
