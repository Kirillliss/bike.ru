class ThroughProductCharacteristic < ActiveRecord::Base
  belongs_to :product
  belongs_to :characteristic_name
end
