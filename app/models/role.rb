class Role < ActiveRecord::Base
  has_many :assignments

  def self.all_as_symbols
    all.map {|r| r.to_sym}
  end

  def to_sym
    self.name.to_sym
  end

end
