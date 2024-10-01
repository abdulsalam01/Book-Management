class Author < ApplicationRecord
  belongs_to :user
  has_many :books, dependent: :destroy

  validates :name, presence: true
end
