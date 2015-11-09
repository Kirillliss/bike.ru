class AddPublishedToHomePageBanners < ActiveRecord::Migration
  def change
    add_column :home_page_banners, :published, :boolean, default: false
  end
end
