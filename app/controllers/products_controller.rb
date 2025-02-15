class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(10)
    respond_to do |format|
      format.json { render json: @products }
    end
  end

  def import
    url = params[:url]

    if url.present?
      ImportProductJob.perform_later(url)
      render json: {message: 'Product import has been initiated'}, status: :accepted
    else
      Rails.logger.error "Missing URL"
      render json: { error: "Missing URL" }, status: :unprocessable_entity
    end
  end
end
