class SendBookCreationEmailJob
  include Sidekiq::Job

  def perform(book_id)
    book = Book.find(book_id)

    # Send the email using the BookMailer
    BookMailer.new_book_email(book).deliver_now
  end
end
