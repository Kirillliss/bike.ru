class AddProductTitleToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :product_title, :string
  end
end
