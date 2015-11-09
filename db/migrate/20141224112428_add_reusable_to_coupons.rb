class AddReusableToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :reusable, :boolean, default: false
  end
end
