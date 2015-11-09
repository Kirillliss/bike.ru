class AddOneAssIdToProductOffer < ActiveRecord::Migration
  def change
    add_column :product_offers, :one_ass_id, :string
  end
end
