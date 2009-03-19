class Journal < ActiveRecord::Base
  has_many :journal_operation
  has_one :company
end
