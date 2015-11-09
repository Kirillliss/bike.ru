class AddPriceOfShippingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :price_of_shipping, :float, default: 0.0
  end
end
