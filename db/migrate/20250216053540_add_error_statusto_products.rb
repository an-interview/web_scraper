class AddErrorStatustoProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :status, :boolean, default: false
    add_column :products, :error, :text
  end
end
