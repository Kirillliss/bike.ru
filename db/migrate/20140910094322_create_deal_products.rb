class CreateDealProducts < ActiveRecord::Migration
  def change
    create_table :deal_products do |t|
      t.belongs_to :deal, index: true
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
