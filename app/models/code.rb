class Code
  class << self
    def [](k)
  	  code = {
         :wish_list_book => 'WB'
        }
      if code[k.to_sym].present?
        return code[k.to_sym]
      else
        raise "Code not found"
      end
    end
   end
end