class CreateProductSites < ActiveRecord::Migration
  def change
    create_table :product_sites do |t|
      t.belongs_to :product, index: true
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
