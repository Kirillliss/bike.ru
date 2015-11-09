class AddOfferLimitToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :offer_limit, :integer
  end
end
