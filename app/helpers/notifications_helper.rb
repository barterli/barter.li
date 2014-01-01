module NotificationsHelper
  def get_notify_sender_email(notification)
     # user = (current_user.id == notification.notifier_id) ? notification.user_id : notification.notifier_id
     if(notification.sent_by.present?)
       email = User.find(notification.sent_by).try(:email)
       email
     else
       return " "
     end
   end
  
  def get_barter_book_name(barter)
    book_name = Book.find(barter.book_id).try(:title)
    book_name
  end 

  def get_notification_message(notification, length)
  	truncate(notification.message, :length => length)
  end

  # sample foursquare response from result[:groups][0][:items][0]
  # <Hashie::Mash categories=[#<Hashie::Mash icon="https://ss1.4sqi.net/img/categories/food/cafe.png" id="4bf58dd8d48988d16d941735" 
  # name="Café" parents=["Food"] pluralName="Cafés" primary=true shortName="Café">] 
  # contact=#<Hashie::Mash formattedPhone="+91 80 4121 3101" phone="+918041213101"> id="511e3cbee4b0eb757871c15b" likes=#<Hashie::Mash count=0 groups=[]> 
  # location=#<Hashie::Mash address="#84, S.T.Bed Layout, 4th Block Koramangala" cc="IN"
  # city="Bangalore" country="India" distance=4359 lat=12.93516201597191 lng=77.63097871416265 postalCode="560034" state="Karnataka"> 
  # name="Coffee On Canvas" restricted=true stats=#<Hashie::Mash checkinsCount=1115 tipCount=34 usersCount=393> verified=false>   
  def user_hangouts
    places = Array.new
    hangouts = current_user.near_by_hangouts
    if(hangouts[:groups].present?)
      hangouts[:groups][0][:items].each do |hangout|
        address = hangout.location.address
        name = hangout.name
        name = " " if name.nil? #to prevent nil to string in array push
        address = " " if address.nil? 
        places.push(name+','+address)
      end
    end
    return places
  end

end

