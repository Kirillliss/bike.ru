class AddProducerIdToImports < ActiveRecord::Migration
  def change
    add_reference :imports, :producer, index: true
  end
end
