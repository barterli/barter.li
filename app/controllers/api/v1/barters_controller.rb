class Api::V1::BartersController < Api::V1::BaseController
  before_action :authenticate_user!

  def send_barter_notification
    book = Book.find(params[:book_id])
    book_owner = User.find(book.user_id)
    if(Notifier.barter_request(book_owner, current_user, book, params[:message]).deliver)
      render json: {status: :success}
    else
      render json: {status: :error}
    end
  end


end