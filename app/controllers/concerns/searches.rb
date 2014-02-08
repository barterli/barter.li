 module Searches
  extend ActiveSupport::Concern
  def search_books
  	params[:search_filter] = {:city => params[:city], :barter_type => params[:barter_type]}
  	if(params[:search].to_s =~ /^[0-9]{10}$|^[0-9]{13}$/ )
  	  params[:search_filter][:isbn] = params[:search]
  	else
  	  params[:search_filter][:book_or_author] = params[:search]
  	end
    @books = Book.search(params[:search_filter]).page(params[:page]).per(params[:per])
    respond_to do |format|
       format.html
       format.json {render json:{books: @books}}
    end
  end
end