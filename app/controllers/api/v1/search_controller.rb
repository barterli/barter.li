class Api::V1::SearchController < Api::V1::BaseController
 
  # GET /search
  def search
    params[:radius] ||= 10
  	params[:search_filter] = {:latitude => params[:latitude], :longitude => params[:longitude]}
    params[:search_filter][:radius] = params[:radius]
  	if(params[:search].to_s =~ /^[0-9]{10}$|^[0-9]{13}$/ )
  	  params[:search_filter][:isbn] = params[:search]
  	else
  	  params[:search_filter][:book_or_author] = params[:search]
  	end
    @books = Book.search(params[:search_filter]).page(params[:page]).per(params[:per])
    render json: {books: @books}
  end

  
  def add_wishlist
    if(@books.blank? && current_user.present? && params[:search][:title].present?)
      current_user.wish_lists.create!(:title => params[:search][:title])
      return
    end
    if(@books.blank? && current_user.present? && params[:search][:author].present?)
      current_user.wish_lists.create!(:author => params[:search][:author])
      return
    end
  end

end