# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

   DefaultSetting.create_setting("email_per_month", "7")
   DefaultSetting.create_setting("email_duration", "4")
   
   if Tag.first.blank?
   	Tag.create([{name: "free"},{name: "sale"},{name: "barter"}, {name: "private"},{name: "rent"}, {name: "read"}])
   end