class AddOtherFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :old_price, :float
    add_column :products, :article, :string
  end
end
