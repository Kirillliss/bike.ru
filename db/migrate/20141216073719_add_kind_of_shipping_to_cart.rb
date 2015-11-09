class AddKindOfShippingToCart < ActiveRecord::Migration
  def change
    add_column :carts, :kind_of_shipping, :string
  end
end
