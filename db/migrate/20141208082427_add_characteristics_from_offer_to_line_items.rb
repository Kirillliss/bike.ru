class AddCharacteristicsFromOfferToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :characteristics_from_offer, :string
  end
end
