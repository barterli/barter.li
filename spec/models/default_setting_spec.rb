require 'spec_helper'

describe DefaultSetting do
  it "should create setting and respond to as a method" do
    DefaultSetting.create_setting("email_per_month", 10)
    DefaultSetting.email_per_month.should eq("10")
  end
end
