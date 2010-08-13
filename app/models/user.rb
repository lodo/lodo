require 'digest/sha1'

class User < ActiveRecord::Base

  include ::PropertyModel

  has_many :companies, :through => :assignments, :uniq => true, :order => "companies.name"
  belongs_to :current_company, :class_name => 'Company'

  has_many :assignments, :include => [:company, :role], :order => "companies.name"
  accepts_nested_attributes_for :assignments, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs["company_id"].blank? || attrs["role_id"].blank? }
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable,
	:trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :assignments_attributes

  self.per_page = 20

  # return array of roles for self.current_company
  def role_symbols
    return @symbols if defined? @symbols
    if self.current_company
      @symbols = self.assignments.where("company_id is null or company_id = ?", self.current_company.id).map {|a| a.role.name.to_sym}
    else
      @symbols = self.assignments.where("company_id is null").map {|a| a.role.name.to_sym}
    end
  end
  
  def open_periods(company = self.current_company)
    Period.where(:company_id => company.id, :status => Period::STATUSE_NAMES['Open'])
  end
  
  # declarative_auth wants a login attribute for the introspection ui
  def login
    self.email
  end

  def to_s
    return email
  end

end
