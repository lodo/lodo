class Project < ActiveRecord::Base
  belongs_to :address, :dependent => :destroy
  belongs_to :company
  accepts_nested_attributes_for :address
  attr_protected :company_id, :company

  def to_s
    return name
  end

end

