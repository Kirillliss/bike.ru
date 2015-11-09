class Site < ActiveRecord::Base
  has_many :category_sites
  has_many :categories, through: :category_sites
  validates :title, presence: true
end
