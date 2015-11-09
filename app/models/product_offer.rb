class ProductOffer < ActiveRecord::Base
  belongs_to :product
  has_many :offer_prices, dependent: :destroy
  has_many :offer_characteristics, dependent: :destroy

  scope :aviable, -> { where.not quantity: 0 }

end
