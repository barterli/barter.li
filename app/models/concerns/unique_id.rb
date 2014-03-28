require 'securerandom'

# the class using this module should have a field in the 
# format id_(modelname)
module UniqueId
  
  extend ActiveSupport::Concern
   included do
      after_create :model_generate_unique_id
    end
   
   # generate unique string id for models
   def model_generate_unique_id
   	 uuid = self.id.to_s+"_"+SecureRandom.hex(5)
     self.send("id_"+self.class.name.downcase+"=", uuid)
     self.save
   end

end