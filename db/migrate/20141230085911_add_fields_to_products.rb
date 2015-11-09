class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :special_title, :string
    add_column :products, :special_slogan_red, :string
    add_column :products, :special_text, :text
    add_column :products, :special_button, :string
    add_column :products, :special_image, :string
    add_column :products, :special_active, :boolean, default: false
  end
end
