class AddPriceFromOfferToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :price_from_offer, :float
  end
end
