class Activatable < ActiveRecord::Base
  has_many :active_periods
end
