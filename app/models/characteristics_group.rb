class CharacteristicsGroup < ActiveRecord::Base
  has_many :characteristics_group_rows
  has_many :products
end
