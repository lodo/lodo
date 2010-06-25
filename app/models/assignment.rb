class Assignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  belongs_to :company

  validates :role_id, :uniqueness => {:scope => [:user_id, :company_id]}

end
