class CharacteristicsGroupRow < ActiveRecord::Base
  belongs_to :characteristics_group
  belongs_to :characteristic_name
  has_many :characteristics_group_vls

  def characteristic_title
    characteristic_name.title
  end

end
