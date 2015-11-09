class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :seo_title
      t.string :seo_keywords
      t.text :seo_description
      t.integer :position
      t.string :ancestry

      t.timestamps
    end
  end
end
