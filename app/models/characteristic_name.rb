class CharacteristicName < ActiveRecord::Base
  has_many :through_product_characteristics
  has_many :products, through: :through_product_characteristics
  has_many :characteristic_values
end
