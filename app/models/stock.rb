class Stock < ActiveRecord::Base
  has_many :imports, dependent: :destroy
  has_many :products
end
