class AddProducerPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :producer_price, :float
  end
end
