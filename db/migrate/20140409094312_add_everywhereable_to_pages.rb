class AddEverywhereableToPages < ActiveRecord::Migration
  def change
    add_column :pages, :everywhereable, :boolean, default: false
  end
end
