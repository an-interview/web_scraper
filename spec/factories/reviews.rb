FactoryBot.define do
  factory :review do
    product
    rating { "9.99" }
    comment { "My first reviews of a good product." }
  end
end
