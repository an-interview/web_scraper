class ImportProductJob < ApplicationJob
  queue_as :default

  def perform(url)
    headers = { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" }
    
    response = HTTParty.get(url, { headers: headers })
    begin
      product_data = Nokogiri::HTML(response.body)

      name = product_data.at_xpath('//h1[1]/span[2]').text
      price = product_data.at_css('div.Nx9bqj.CxhGGd').text.to_f
      image_url = product_data.at_css('div.gqcSqV.YGE0gZ img')['src']
      category_name = product_data.css('div._7dPnhA > div:nth-of-type(2) a').text
      brand_name = product_data.at_xpath('//h1[1]/span[1]').text
      rating = product_data.at_css('#sellerName > span > div:first-of-type').text.to_f
      review_count = product_data.at_css('#container > div > div._39kFie.N3De93.JxFEK3._48O0EI > div.DOjaWF.YJG4Cf > div.DOjaWF.gdgoEp.col-8-12 > div.DOjaWF.gdgoEp > div:nth-child(6) > div > div.row.q4T7rk._8-rIO3 > div > div > div.col-3-12 > div > div:nth-child(3) > div > span')
      review_count = review_count.nil? ? 0 : review_count.text.to_i

      ActiveRecord::Base.transaction do
        product = Product.create!(
          name: name,
          price: price,
          currency: 'INR', # TODO: Parse currency from currency symbol
          image_url: image_url.split('?')[0],
          source_url: url.split('?')[0],
          rating: rating,
          review_count: review_count
        )

        if category_name
          category = Category.find_or_create_by!(name: category_name)
          product.update!(category: category)
        end

        if brand_name
          brand = Brand.find_or_create_by!(name: brand_name)
          product.update!(brand: brand)
        end
      end
    rescue StandardError => e
      Rails.logger.error "Failed to fetch product data from #{url}: #{response.code}"
      raise ActionController::RoutingError.new('Not Found')
    end
  rescue StandardError => e
    Rails.logger.error "Error importing product from #{url}: #{e.message}"
    raise e
  end
end
