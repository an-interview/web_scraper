FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A high-quality product." }
    price { 199.99 }
    currency { "INR" }
    image_url { "https://example.com/sample.jpg" }
    source_url { "https://example.com/product" }
    scraped_at { Time.current }
    rating { 4.5 }
    review_count { 100 }

    category
    brand
  end
end
