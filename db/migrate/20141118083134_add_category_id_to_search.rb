class AddCategoryIdToSearch < ActiveRecord::Migration
  def change
    add_reference :searches, :category, index: true
  end
end
