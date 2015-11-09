class ChangeAssociatonsOfSiteAndCategories < ActiveRecord::Migration
  def up
    drop_table :sites
    drop_table :category_sites
    drop_table :product_sites
  end

  def down
    create_table :product_sites do |t|
      t.belongs_to :product, index: true
      t.belongs_to :site, index: true

      t.timestamps
    end
    create_table :category_sites do |t|
      t.belongs_to :category, index: true
      t.belongs_to :site, index: true

      t.timestamps
    end
    create_table :sites do |t|
      t.string :title
      t.string :hostname

      t.timestamps
    end
  end
end
