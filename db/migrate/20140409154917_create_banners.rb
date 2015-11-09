class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.text :text
      t.string :image
      t.boolean :topable, default: true
      t.boolean :leftable, default: false
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
