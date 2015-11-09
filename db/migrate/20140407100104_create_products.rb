class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :category, index: true
      t.belongs_to :main_image, index: true
      t.string :title
      t.text :description
      t.float :price
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
