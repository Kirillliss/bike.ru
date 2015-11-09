class AddProducerIdToSearch < ActiveRecord::Migration
  def change
    add_reference :searches, :producer, index: true
  end
end
