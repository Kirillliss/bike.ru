class AddFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :benefit, :boolean, default: false
    add_column :products, :hit, :boolean, default: false
    add_column :products, :markdown, :boolean, default: false
  end
end
