class Deal < ActiveRecord::Base
  has_many :deal_products
  has_many :products, -> { uniq }, through: :deal_products
  scope :aviable, -> {where published: true}
  mount_uploader :image, ImageUploader
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
