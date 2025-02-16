class ImportProductJob < ApplicationJob
  queue_as :default

  def perform(url)
    page = product_data(url)
    create_product_record(url, page: page, status: true, error: nil)
  rescue ActionController::RoutingError => e
    Rails.logger.error "Failed to fetch product data from #{url}: #{e}"
    create_product_record(url, page: nil, status: false, error: "Failed to fetch product data from #{url}")
    raise e
  rescue SocketError => e
    Rails.logger.error 'Unable to reach the web page. Check URL.'
    create_product_record(url, page: nil, status: false, error: 'Unable to reach the web page. Check URL')
    raise e
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Invalid Data"
    create_product_record(url, page: nil, status: false, error: 'Invalid Data')
    raise e
  rescue StandardError => e
    Rails.logger.error "Error importing product from #{url}: #{e.message}"
    create_product_record(url, page: nil, status: false, error: "Error importing product from #{url}")
    raise e
  end

  private

  def number_from_string(str)
    string_arr = str.scan(/(\d+|\D+)/)
    string_arr.flatten
  end

  def create_product_record(url, page: nil, status: false, error: nil)
    # we want to create the record for user's reference when we can't reach the webpage
    # so that user gets change to fix URL error in future
    # sending nil page sets custom value for the failed record
    Product.find_or_create_by!(source_url: url) do |product|
      page_data = data_from_page(page, status, error)

      page_data.keys.each do |attribute|
        product.public_send("#{attribute}=", page_data[attribute])
      end
    end
  end

  def product_data(url)
    headers = { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" }
    response = HTTParty.get(url, { headers: headers })
    Nokogiri::HTML(response.body)
  end

  def data_from_page(page, status: true, error: nil)
    review_count = page ? page.at_css('#container > div > div._39kFie.N3De93.JxFEK3._48O0EI > div.DOjaWF.YJG4Cf > div.DOjaWF.gdgoEp.col-8-12 > div.DOjaWF.gdgoEp > div:nth-child(6) > div > div.row.q4T7rk._8-rIO3 > div > div > div.col-3-12 > div > div:nth-child(3) > div > span') : 0
    category_name = page ? page.css('div._7dPnhA > div:nth-of-type(2) a').text : nil
    brand_name = page ? page.at_xpath('//h1[1]/span[1]').text : nil

    {
      status: status,
      error: error,
      name: page ? page.at_xpath('//h1[1]/span[1]').text : 'N/A',
      price: page ? number_from_string(page.at_css('div.Nx9bqj.CxhGGd').text)[1].to_f : 0.0,
      currency: 'INR', # TODO: Parse currency from currency symbol
      image_url: page ? page.at_css('div.gqcSqV.YGE0gZ img')['src'] : '',
      category: page ? category(category_name) : nil,
      brand: page ? brand(brand_name) : nil,
      rating: page ? page.at_css('#sellerName > span > div:first-of-type').text.to_f : 0.0,
      review_count: review_count.nil? ? 0 : review_count
    }
  end

  def category(category_name)
    return nil unless category_name

    category = Category.find_or_create_by!(name: category_name)
  end

  def brand(brand_name)
    return nil unless  brand_name

    brand = Brand.find_or_create_by!(name: brand_name)
  end
end
