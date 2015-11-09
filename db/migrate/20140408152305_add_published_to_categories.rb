class AddPublishedToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :published, :boolean, deafult: false
  end
end
