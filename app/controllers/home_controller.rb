class HomeController < ApplicationController
  def index
    author_ids = current_user.authors.pluck(:id)
    
    @total_books = Book.where(author_id: author_ids).count
  end
end
