class ChangeDefaultPriceToProducts < ActiveRecord::Migration
  def change
    change_column_default :products, :price,  0.0
  end
end
