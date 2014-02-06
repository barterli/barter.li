class Code
  class << self
    def [](k)
  	  code = {
         :wish_list_book => 'WB',
         :etag_last_modified => Time.new(2014, 01, 03),
         :barter_categories => {:free => 1,
            :barter => 2,
            :sale => 3,
            :read => 4
           },
          :membership => {
            :unapproved => 0,
            :approved => 1
          },
          :publish_type => {
            :public => 1,
            :private => 2
          }          
        }
      if code[k.to_sym].present?
        return code[k.to_sym]
      else
        raise "Code not found"
      end
    end
   end
end