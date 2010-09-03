class TaxZone < ActiveRecord::Base
  has_many :tax_zone_taxes
end
