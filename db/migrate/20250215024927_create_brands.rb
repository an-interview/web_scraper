class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name

      t.timestamps
    end
    add_index :brands, :name
  end
end
