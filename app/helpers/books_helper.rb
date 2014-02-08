module BooksHelper
 
  def book_image(book)
    image = book.image_url
    return image.present? ? image : "/assets/book.jpg"
  end

  def book_city(book)
  	book_location = book.location
    return book_location.present? ? book_location.city : "Not Present"
  end

end