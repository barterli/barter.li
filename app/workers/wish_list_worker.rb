class WishListWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(book_id)
  	book = Book.find(book_id)
    User.find_each(batch_size: 500) do |user|
      wishlist = user.wishlists.where('title = :book or author = :author', {title: book.tilte, author: book.author}).first
      if(wishlist.present?)
      	user.create_alert(book, Code[:wish_list_book])
        user.mail_wish_list(book, wishlist)
      end
    end
  end
end

