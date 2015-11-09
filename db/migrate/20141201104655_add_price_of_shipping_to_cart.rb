class AddPriceOfShippingToCart < ActiveRecord::Migration
  def change
    add_column :carts, :price_of_shipping, :float, default: 0.0
  end
end
