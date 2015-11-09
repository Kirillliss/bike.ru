class AddStockIdToImports < ActiveRecord::Migration
  def change
    add_reference :imports, :stock, index: true
  end
end
