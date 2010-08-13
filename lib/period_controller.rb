
module PeriodController
  
  def self.included(c)
    c.helper_method :first_period
    c.helper_method :last_period
  end

  def first_period
    user_property( :first_period, "#{Time.now.year} 01")
  end

  def last_period
    user_property( :last_period, "#{Time.now.year} 12")
  end

  def period_filter list
    
    first_period = user_property( :first_period, "#{Time.now.year} 01").split
    last_period = user_property( :last_period, "#{Time.now.year} 12").split
    
    first_year = first_period[0]
    last_year = last_period[0]
    first_nr = first_period[1]
    last_nr = last_period[1]
    
    if first_year == last_year
      list.joins(:period).where("(periods.year = :first_year and periods.nr >= :first_nr and periods.nr <= :last_nr)", 
                                { :first_year => first_year,
                                  :first_nr => first_nr,
                                  :last_nr => last_nr })
    else
      list.joins(:period).where("((periods.year > :first_year and periods.year < :last_year) or (periods.year = :first_year and periods.nr >= :first_nr) or (periods.year = :last_year and periods.nr <= :last_nr))", 
                                { :first_year => first_year,
                                  :last_year => last_year,
                                  :first_nr => first_nr,
                                  :last_nr => last_nr })
    end
  end


end

