class ChangeTypePriceFromOffer < ActiveRecord::Migration
  def up
    change_column :line_items, :price_from_offer, :string
  end

  def down
    change_column :line_items, :price_from_offer, :float
  end
end
