class Code
  class << self
    def [](k)
  	  code = {
         :wish_list_book => 'WB',
         :etag_last_modified => Time.new(2014, 01, 03)
        }
      if code[k.to_sym].present?
        return code[k.to_sym]
      else
        raise "Code not found"
      end
    end
   end
end