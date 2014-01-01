class WishlistWorker
  include Sidekiq::Worker
  
  def perform(book_id)
    # pending
  end
end

