class BooksController < ApplicationController
  before_action :set_book, only: [ :destroy ]

  def index
    @books = Book.joins(:author).where(authors: { user_id: current_user.id }).page(params[:page]).per(5)
  end

  def create
    ActiveRecord::Base.transaction do
      # Find or create the author for the current user.
      author = current_user.authors.first_or_create!(name: current_user.email)

      # Build the book associated with the user's author.
      @book = author.books.build(book_params)

      # Save the book, will raise an exception if it fails and rollback the transaction.
      @book.save!

      # Enqueue the email job after saving the book.
      SendBookCreationEmailJob.perform_async(@book.id)
    end

    redirect_to books_path, notice: "Book was successfully created."
  rescue ActiveRecord::RecordInvalid => e
    # Handle any validation failures or transaction errors.
    flash[:alert] = "There was an error creating the book: #{e.message}"
    render :new
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to books_path, alert: "Failed to delete book: #{e.message}"
  end

  private

  def book_params
    params.require(:book).permit(:title, :year)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
