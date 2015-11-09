class AddImportIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :import, index: true
  end
end
