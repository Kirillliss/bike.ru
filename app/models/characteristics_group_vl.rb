class CharacteristicsGroupVl < ActiveRecord::Base
  belongs_to :characteristics_group_row
  belongs_to :characteristic_value
end
