class AddOneAssColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :one_ass_id, :string
    add_column :products, :last_oneassed_at, :timestamp
  end
end
