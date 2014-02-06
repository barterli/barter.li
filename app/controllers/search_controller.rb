class SearchController < ApplicationController
  
  def search_books
  	set_search_params
  	# uses kaminari for pagination
    @books = Book.search(params[:search]).page(params[:page]).per(params[:per])
    # add to wish list if search result is empty
    add_wishlist
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

  private
    def set_search_params
    	if(current_user.present? && params[:search].present?)
        params[:search][:user_id] = current_user.id
      end
      if(current_user.present? && params[:search].blank?)
        params[:search]= {:user_id => current_user.id}
      end
    end
end
