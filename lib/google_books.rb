Book.all.each do |b|
  if b.ext_image_url.present?
     gbook = GoogleBooks.search("title:#{b.title}", {:api_key => ENV['GOOGLE_BOOKS']}).first
     next if gbook.blank?
     image_link = gbook.image_link(:zoom => 1)
      if(image_link.present?)
      	puts image_link
      	puts b.id
        b.ext_image_url = image_link
        b.save
      end
  end
end