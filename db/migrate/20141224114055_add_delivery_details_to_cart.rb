class AddDeliveryDetailsToCart < ActiveRecord::Migration
  def change
    add_column :carts, :city_code, :integer
    add_column :carts, :city_title, :string
    add_column :carts, :region_code, :integer
    add_column :carts, :region_title, :string
  end
end
