class Banner < ActiveRecord::Base
  validates :title, :image, :text, presence: true
  mount_uploader :image, ImageUploader

  scope :published, ->{ where(published: true) }
  scope :slider, ->{ where( topable: true )}
end
