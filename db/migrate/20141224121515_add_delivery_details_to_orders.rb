class AddDeliveryDetailsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :city_code, :integer
    add_column :orders, :city_title, :string
    add_column :orders, :region_code, :integer
    add_column :orders, :region_title, :string
  end
end
