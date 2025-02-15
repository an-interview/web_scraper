class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.string :currency
      t.string :image_url
      t.string :source_url, null: false
      t.datetime :scraped_at, null: false
      t.string :category
      t.string :brand
      t.decimal :rating, precision: 3, scale: 2
      t.integer :review_count

      t.timestamps
    end
  end
end
