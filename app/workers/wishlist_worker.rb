class WishlistWorker
  include Sidekiq::Worker
  #sidekiq_options retry: false
  def perform(book_id)
    # pending
  end
end

