class WishListWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(book_id)
  	book = Book.find(book_id)
    User.find_each(batch_size: 500) do |user|
      wishlist = user.wish_lists.where('title = :title or author = :author', {title: book.title, author: book.author}).first
      if(wishlist.present?)
      	user.create_alert(book, Code[:wish_list_book])
        user.mail_wish_list(book, wishlist)
      end
    end
  end
end

