class SpecialOffer < ActiveRecord::Base
  belongs_to :product_one, class_name: Product
  belongs_to :product_two, class_name: Product
  has_many :line_items

  validate :verify_correct_price

  def verify_correct_price
    if special_price > product_one.price + product_two.price
      errors.add(:special_price, "Специальная цена не может быть больше суммы цен товаров")
    end
  end

  def self.random_offer
    self.find(self.ids.sample)
  end

end
