# spec/factories/authors.rb
FactoryBot.define do
  factory :author do
    name { "Author Name" }
    user # This creates an associated user if you have the association defined
  end
end
