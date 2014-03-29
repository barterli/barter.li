# include this module in models where has_and_belongs_to_many asscociation
# changes touches the updated_at column of included model.
module HabtmTouchId
  
  extend ActiveSupport::Concern
  included do
      after_initialize :create_touch_true_has_and_belongs_to_many
  end
  
   def create_touch_true_has_and_belongs_to_many
     association = self.class.name.constantize.reflect_on_all_associations(:has_and_belongs_to_many)
     association.each do |assoc|
       next if assoc.plural_name.blank?
       name = assoc.plural_name.chop!+"_ids="
       self.class.send(:define_method, name, lambda { |ids| 
         self.updated_at = Time.now
         super(ids)
          })
     end
   end

end

