
module PropertyModel
  
  def get_property key
    res = Property.where(:key => key.to_s, :model_id => self.id, :model_name => self.class.to_s).first
    res ? ActiveSupport::JSON.decode(res.value):nil
  end
  
  def check_property key, default
    res = Property.where(:key => key.to_s, :model_id => self.id, :model_name => self.class.to_s).first
    if res
      ActiveSupport::JSON.decode(res.value)
    else
      Property.create :key => key.to_s, :model_id => self.id, :model_name => self.class.to_s, :value => default.to_json
      default
    end
  end
  
  def set_property key, value
    res = Property.where(:key => key.to_s, :model_id => self.id, :model_name => self.class.to_s).first
    if res
      res.value = value.to_json
      res.save
    else
      Property.create :key => key.to_s, :model_id => self.id, :model_name => self.class.to_s, :value => value.to_json
    end
    value
  end

  def destroy_property key
    res = Property.where(:key => key.to_s, :model_id => self.id, :model_name => self.class.to_s).first
    if res
      res.destroy
    end
  end

end

