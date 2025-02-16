class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :brand, optional: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :currency, presence: true, length: { is: 3 } # Example: "INR"
  validates :image_url, format: { with: /\Ahttps?:\/\/.*\.(?:jpg|jpeg|png|gif|webp)(\?.*)?\z/i, message: "must be a valid image URL" }, allow_blank: true
  validates :source_url, format: { with: /\Ahttps?:\/\/.+\z/i, message: "must be a valid URL" }, presence: true, uniqueness: true
  # validates :scraped_at, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validates :review_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
