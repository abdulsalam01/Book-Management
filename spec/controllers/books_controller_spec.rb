require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let!(:user) { create(:user) }  # Create a user
  let!(:author) { create(:author, user: user) }  # Create an author associated with the user
  let!(:book) { create(:book, author: author) }   # Create a book associated with the user

  # Create another user and author for the second book
  let!(:another_user) { create(:user, email: 'another_user@example.com') } # Ensure a unique email
  let!(:another_author) { create(:author, user: another_user) } # Create a different author
  let!(:another_book) { create(:book, author: another_author) }  # Create a book for another author

  before do
    sign_in user  # Sign in the user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index  # Perform the GET request
      expect(response).to have_http_status(:success)  # Expect a successful response (200)
    end

    it 'assigns @books with user\'s books' do
      get :index  # Perform the GET request
      expect(assigns(:books)).to match_array([ book ])  # Expect assigned @books to include only the user’s books
    end

    it 'does not include books not associated with the user' do
      get :index  # Perform the GET request
      expect(assigns(:books)).not_to include(another_book)  # Ensure other user’s books are not included
    end
  end

  describe 'POST #create' do
    let(:book_params) { { title: 'New Book Title', year: 2024 } } # Define valid book parameters

    context 'with valid parameters' do
      it 'creates a new book' do
        expect {
          post :create, params: { book: book_params } # Perform the POST request
        }.to change(Book, :count).by(1) # Expect the book count to increase by 1
      end

      it 'redirects to the books index with a success notice' do
        post :create, params: { book: book_params } # Perform the POST request
        expect(response).to redirect_to(books_path) # Expect a redirect to books_path
        expect(flash[:notice]).to eq("Book was successfully created.") # Expect success message
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new book' do
        expect {
          post :create, params: { book: { title: '' } } # Invalid title
        }.not_to change(Book, :count) # Expect the book count not to change
      end

      it 'renders the new template with an error message' do
        post :create, params: { book: { title: '' } } # Invalid title
        expect(response).to render_template(:new) # Expect to render the new template
        expect(flash[:alert]).to eq("There was an error creating the book: Validation failed: Title can't be blank, Year can't be blank, Year is not a number") # Expect error message
      end
    end
  end
end
