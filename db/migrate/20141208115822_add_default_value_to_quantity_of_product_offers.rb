class AddDefaultValueToQuantityOfProductOffers < ActiveRecord::Migration
  def up
    change_column :product_offers, :quantity, :integer, :default => 0
  end

  def down
    change_column :product_offers, :quantity, :integer, :default => nil
  end
end
