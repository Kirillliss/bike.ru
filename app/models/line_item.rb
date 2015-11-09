class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :special_offer
  belongs_to :cart

  has_many :line_item_characteristics

  def line_poduct
    product ? product : special_offer
  end

  def total_price
    if product
      # Цена * коэффициент * количество
      if price_from_offer
        price_from_offer.split('/').first.to_f * price_from_offer.split('/').second.to_i * quantity
      else
        product.price * quantity
      end
    elsif special_offer
      special_offer.special_price * quantity
    end
  end

  def price
    if product
      if price_from_offer
        price_from_offer.split('/').first.to_f * price_from_offer.split('/').second.to_i
      else
        product.price
      end
    elsif special_offer
      special_offer.special_price
    end
  end

end
