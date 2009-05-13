class Period < ActiveRecord::Base
  belongs_to :company

  STATUSES = {0 => 'New', 1 => 'Open', 2 => 'Done', 3 => 'Closed'}
  STATUSE_NAMES = {'New' => 0, 'Open' => 1, 'Done' => 2, 'Closed' => 3}

  def status_name
    STATUSES[self.status]
  end

  def open?
     self.status == 1
  end
end
