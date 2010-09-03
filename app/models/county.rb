class County < ActiveRecord::Base
  has_many :county_tax_zones
end
