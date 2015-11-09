class LineItemCharacteristic < ActiveRecord::Base
  belongs_to :characteristic_name
  belongs_to :characteristic_value
  belongs_to :line_item
end
