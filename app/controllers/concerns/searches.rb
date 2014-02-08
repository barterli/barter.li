 module Searches
  extend ActiveSupport::Concern
  def search
  	params[:search_filter] = {:city => params[:city]}
  	if(params[:search].to_s =~ /^[0-9]{10}$|^[0-9]{13}$/ )
  	  params[:search_filter][:isbn] = params[:search]
  	else
  	  params[:search_filter][:book_or_author] = params[:search]
  	end
    @books = Book.search(params[:search_filter]).page(params[:page]).per(params[:per])
    respond_with @books
  end
end