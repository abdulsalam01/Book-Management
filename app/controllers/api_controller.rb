class ApiController < ApplicationController
  def index
    @books = Book
      .joins(:author)
      .where(authors: { user_id: current_user.id })
      .page(params[:page])
      .per(params[:per_page] || 10)

    render json: {
      data: @books.as_json(include: {
        author: {
          only: [ :id, :name, :created_at ]
        }
      })
    }
  end
end
