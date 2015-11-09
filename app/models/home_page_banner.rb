class HomePageBanner < ActiveRecord::Base

  mount_uploader :image_big, ImageUploader
  mount_uploader :image_small, ImageUploader

  scope :published, -> { where published: true }

end
