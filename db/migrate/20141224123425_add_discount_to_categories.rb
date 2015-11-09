class AddDiscountToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :discount, index: true
  end
end
