class Review < ApplicationRecord
  belongs_to :product
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :comment, length: { maximum: 500 }, allow_blank: true
end
