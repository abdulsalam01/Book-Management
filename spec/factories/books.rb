# spec/factories/books.rb
FactoryBot.define do
  factory :book do
    title { "Sample Book" }
    year { 2023 }
    association :author
  end
end
