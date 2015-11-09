class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :permalink
      t.string :seo_title
      t.string :seo_keywords
      t.text :seo_description
      t.text :body
      t.boolean :published, deafult: false
      t.string :ancestry

      t.timestamps
    end
  end
end
