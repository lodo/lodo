class Account < ActiveRecord::Base
  has_many :ledgers, :dependent => :destroy, :order => "lower(name)"
  belongs_to :company
  belongs_to :activatable
end
