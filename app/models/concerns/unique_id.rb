require 'securerandom'

# the class using this module should have a field in the 
# format id_(modelname)
module UniqueId
  
  extend ActiveSupport::Concern
   included do
      after_create :model_set_unique_id
    end
   
   # generate unique string id for models
   def model_set_unique_id
   	 field_name = "id_"+self.class.name.downcase
   	 guid = self.model_generate_unique_id(field_name)
     self.send(field_name+"=", guid)
     self.save
   end

   def model_generate_unique_id(field_name)
     loop do
        guid = SecureRandom.hex(8)
        break guid unless self.class.name.constantize.where(:"#{field_name}" => guid).first
      end
   end

end

