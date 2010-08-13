class Journal < ActiveRecord::Base
  has_many :journal_operations, :autosave => true
  belongs_to :company
  belongs_to :bill
  belongs_to :period

  self.per_page = 200

  def open?
   return (not self.closed)
  end

  def editable?
    return (self.period.open? and self.open? and self.bill_id.nil?)
  end
end
