class AddDefaulttoScrapedAt < ActiveRecord::Migration[7.1]
  def change
    change_column_default :products, :scraped_at, -> { 'CURRENT_TIMESTAMP'}
  end
end
