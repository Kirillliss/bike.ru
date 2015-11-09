class AddFieldsToCategpries < ActiveRecord::Migration
  def change
    add_column :categories, :special_image, :string
    add_column :categories, :special_active, :boolean, default: false
  end
end
