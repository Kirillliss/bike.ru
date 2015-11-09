class AddSeoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :seo_title, :string
    add_column :products, :seo_keywords, :string
    add_column :products, :seo_description, :text
  end
end
