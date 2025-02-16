class ProductSerializer < ActiveModel::Serializer
  attributes :status, :error, :id, :image_url, :name, :price, :description, :currency, :source_url, :scraped_at, :rating, :review_count

  belongs_to :category
  belongs_to :brand
end
