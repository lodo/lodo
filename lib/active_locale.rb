require "bigdecimal"

class Hash
  def self.from_pairs(lst)
    hsh = new
    lst.each do |i|
      hsh[i[0]] = i[1]
    end
  end
end

class String
  alias :old_to_d :to_d
  def to_d
    ((self.to_s.gsub ' ', '').gsub ',','.').old_to_d
  end
end


# Hackety hack...
module ActiveRecord::Validations::ClassMethods
  def validates_numericality_of(*attr_names)
    configuration = { :on => :save, :only_integer => false, :allow_nil => false }
    configuration.update(attr_names.extract_options!)


    numericality_options = ALL_NUMERICALITY_CHECKS.keys & configuration.keys

    (numericality_options - [ :odd, :even ]).each do |option|
      raise ArgumentError, ":#{option} must be a number" unless configuration[option].is_a?(Numeric)
    end

    validates_each(attr_names,configuration) do |record, attr_name, value|
      raw_value = record.send("#{attr_name}_before_type_cast") || value

      next if configuration[:allow_nil] and raw_value.nil?

      if configuration[:only_integer]
	unless raw_value.to_s =~ /\A[+-]?\d+\Z/
	  record.errors.add(attr_name, :not_a_number, :value => raw_value, :default => configuration[:message])
	  next
	end
	raw_value = raw_value.to_i
      else
	begin
	  #### fixme ####
	  # description = """This hacketyhack gets to live, solely to support the next line, and only the next line
          # It is there, as Kernel.Float does not call to_d on String objects, for some f**ed up reason"""
          #### end ####
	  raw_value = value.to_s.to_d
	rescue ArgumentError, TypeError
	  record.errors.add(attr_name, :not_a_number, :value => raw_value, :default => configuration[:message])
	  next
	end
      end

      numericality_options.each do |option|
	case option
	  when :odd, :even
	    unless raw_value.to_i.method(ALL_NUMERICALITY_CHECKS[option])[]
	      record.errors.add(attr_name, option, :value => raw_value, :default => configuration[:message]) 
	    end
	  else
	    record.errors.add(attr_name, option, :default => configuration[:message], :value => raw_value, :count => configuration[option]) unless raw_value.method(ALL_NUMERICALITY_CHECKS[option])[configuration[option]]
	end
      end
    end
  end
end
