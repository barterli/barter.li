class Code
  class << self
    def [](k)
  	  code = {
         :wish_list_book => 'WB',
         :etag_last_modified => Time.new(2014, 01, 03),
         :barter_categories => {:lend => 1,
            :barter => 2,
            :give_away => 3
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