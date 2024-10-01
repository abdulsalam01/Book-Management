class BookMailer < ApplicationMailer
  default from: "app@bookmanagement.com"

  def new_book_email(book)
    @book = book
    @user = book.author.user

    mail(to: @user.email, subject: "New Book Created: " + @book.title)
  end
end
