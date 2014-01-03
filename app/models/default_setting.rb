class DefaultSetting < ActiveRecord::Base
  
  def self.create_setting(name, value)
  	setting = DefaultSetting.find_by(:name => name)
  	unless setting.present?
      setting = DefaultSetting.new
      setting.name = name
      setting.value = value
      setting.save
    end
  end

  def self.method_missing(name, *args, &blk)
  	setting = DefaultSetting.find_by(name: name)
    if setting.present?
      setting.value
    else
      super
    end
  end

end
