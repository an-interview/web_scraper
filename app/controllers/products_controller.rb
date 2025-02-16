class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(10)

    render json: @products, each_serializer: ProductSerializer
  end

  def import
    url = params[:url]

    if valid_url?(url)
      ImportProductJob.perform_later(url)
      render json: { message: 'Product import has been initiated' }, status: :accepted
    else
      Rails.logger.error "Invalid Or Missing URL"
      render json: { errors: "Invalid Or Missing URL" }, status: :bad_request
    end
  end

  private

  def valid_url?(url)
    return false if url.blank?

    begin
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
end
