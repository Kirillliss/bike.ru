class AddProducerIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :producer, index: true
  end
end
