class ActiveRecord::Base
  def self.create_or_update(params)
    if params.has_key? 'id' and params['id'] != 'undefined' 
      obj = self.find params['id']
      params.each do |key, value|
        obj.send key + "=", value
      end
    else
      obj = self.new params
    end
    obj
  end
end
