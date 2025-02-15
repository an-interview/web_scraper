class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :rating, precision: 3, scale: 2
      t.text :comment

      t.timestamps
    end
  end
end
