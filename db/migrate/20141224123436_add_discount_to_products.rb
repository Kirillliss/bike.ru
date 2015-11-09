class AddDiscountToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :discount, index: true
  end
end
