class CreateHomePageBanners < ActiveRecord::Migration
  def change
    create_table :home_page_banners do |t|
      t.string :title
      t.string :title_red
      t.string :title_small
      t.text :description
      t.string :main_button_title
      t.string :main_button_url
      t.boolean :secondary_button_on, default: false
      t.string :secondary_button_title
      t.string :secondary_button_url
      t.string :image_big
      t.string :image_small

      t.timestamps
    end
  end
end
