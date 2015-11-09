class Discount < ActiveRecord::Base
  has_many :categories
  has_many :products

  validates :title, :amount, presence: true

end
