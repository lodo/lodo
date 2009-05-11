class Journal < ActiveRecord::Base
  has_many :journal_operation
  belongs_to :company
end
