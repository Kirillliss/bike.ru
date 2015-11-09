class AddFrontpageableToProducts < ActiveRecord::Migration
  def change
    add_column :products, :frontpageable, :boolean, default: false
  end
end
