class AddStateColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :state, :string
    Order.update_all(state: :done)
  end
end
