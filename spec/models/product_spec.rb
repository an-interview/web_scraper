require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    
    it { should validate_presence_of(:currency) }
    it { should validate_length_of(:currency).is_equal_to(3) }
    
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5).allow_nil }
    it { should validate_numericality_of(:review_count).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    
    it "validates image_url format" do
      product.image_url = "invalid-url"
      expect(product).to_not be_valid
      expect(product.errors[:image_url]).to include("must be a valid image URL")
      
      product.image_url = "https://example.com/image.jpg"
      expect(product).to be_valid
    end

    it "validates source_url format" do
      product.source_url = "invalid-url"
      expect(product).to_not be_valid
      expect(product.errors[:source_url]).to include("must be a valid URL")
      
      product.source_url = "https://example.com/product"
      expect(product).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:category).optional }
    it { should belong_to(:brand).optional }
  end
end
