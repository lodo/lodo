class PaycheckPeriod < ActiveRecord::Base
  belongs_to :company

  def to_s
    "#{self.start_day}/#{self.start_month} - #{self.stop_day}/#{self.stop_month}"
  end
end
