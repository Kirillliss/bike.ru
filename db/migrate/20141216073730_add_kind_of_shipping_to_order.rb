class AddKindOfShippingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :kind_of_shipping, :string
  end
end
