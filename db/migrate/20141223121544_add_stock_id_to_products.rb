class AddStockIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :stock, index: true
  end
end
