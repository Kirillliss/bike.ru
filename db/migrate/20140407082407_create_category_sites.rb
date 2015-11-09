class CreateCategorySites < ActiveRecord::Migration
  def change
    create_table :category_sites do |t|
      t.belongs_to :category, index: true
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
