require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :assignments
  has_many :companies, :through => :assignments
  belongs_to :current_company, :class_name => 'Company'
  
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation

  
  def open_periods(company = self.current_company)
    Period.find(:all, :conditions => {:company_id => company.id, :status => Period::STATUSE_NAMES['Open']})
  end

end
