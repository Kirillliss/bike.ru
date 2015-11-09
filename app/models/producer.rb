class Producer < ActiveRecord::Base
  has_many :products
  has_many :imports
end
