require 'rails_helper'

RSpec.describe "Products API", type: :request do
  let(:api_key) { ENV['API_KEY'] }
  let!(:category) { create(:category) }
  let!(:brand) { create(:brand) }
  let!(:products) { create_list(:product, 25, category: category, brand: brand) } # Creating 15 products for pagination

  describe "GET /products" do
    before { get "/products", params: { page: 1 }, headers: { 'Trip-Api-Key': api_key }, as: :json }

    it "returns a paginated list of products" do
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(10)
    end

    it "returns the correct product attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to include("id", "name", "description", "price")
    end
  end

  describe "POST /products/import" do
    let(:valid_attributes) do
      { url: 'https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06'  }
    end

    let(:invalid_attributes) do
      { url: 'https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c060000000000' } # Invalid data
    end

    context "when request is valid" do
      it "creates a new product" do
        post "/products/import", params: valid_attributes, headers: { 'Trip-Api-Key': api_key }, as: :json

        expect(response).to have_http_status(:accepted)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Product import has been initiated")
      end

      it "enqueues a background job to fetch product details" do
        expect {
          post "/products/import", params: valid_attributes, headers: { 'Trip-Api-Key': api_key }, as: :json
        }.to have_enqueued_job(ImportProductJob)
      end
    end

    context "when request is invalid" do
      it "returns error for empty URL" do
        post "/products/import", params: { url: nil }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
