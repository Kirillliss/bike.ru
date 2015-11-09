class AddQuantityToProductOffers < ActiveRecord::Migration
  def change
    add_column :product_offers, :quantity, :integer
  end
end
