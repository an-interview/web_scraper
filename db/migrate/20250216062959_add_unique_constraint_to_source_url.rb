class AddUniqueConstraintToSourceUrl < ActiveRecord::Migration[7.1]
  def change
    add_index :products, :source_url, unique: true
  end
end
