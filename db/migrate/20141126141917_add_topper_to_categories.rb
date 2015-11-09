class AddTopperToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :topper, :boolean, default: false
  end
end
