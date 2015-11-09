class AddOneAssIdToProducers < ActiveRecord::Migration
  def change
    add_column :producers, :one_ass_id, :string
  end
end
