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

  def create_next
    year = self.year
    nr = self.nr + 1
    if nr > 13
      nr = 1
      year = year + 1
    end
    return Period.new :company => self.company, :year => year, :nr => nr, :status => Period::STATUSE_NAMES['New']
  end
end
