class AddNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :number, :integer, default: 0
  end
end
