class AddSpoToLineItem < ActiveRecord::Migration
  def change
    add_reference :line_items, :special_offer, index: true
  end
end
