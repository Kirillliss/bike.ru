class ProductCharacteristic < ActiveRecord::Base
  belongs_to :product
  belongs_to :characteristic_name
  belongs_to :characteristic_value
end
