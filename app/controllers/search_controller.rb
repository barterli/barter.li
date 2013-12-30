class SearchController < ApplicationController
  
  def search_books
  	set_search_params
  	#uses kaminari for pagination
    @books = Book.search(params[:search]).page(params[:page]).per(params[:per])
  end


  private
  def set_search_params
  	if(current_user.present? && params[:search].present?)
      params[:search][:user_id] = current_user.id
    end
    if(current_user.present? && !params[:search].present?)
      params[:search]= {:user_id => current_user.id}
    end
  end
end
