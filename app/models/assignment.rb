class Assignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  belongs_to :company

  validates_uniqueness_of :role_id, :scope => [:user_id, :company_id]

end

