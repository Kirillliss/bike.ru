class OfferPrice < ActiveRecord::Base
  belongs_to :product_offer

  DISCOUNT_COEF = 0.75

  # alias_attribute :old_price, :price

  def title
    result = ''
    if product_offer.quantity > 0
      product_offer.offer_characteristics.each do |characteristic|
        result += "#{characteristic.title}: #{characteristic.value}. "
      end
      # result += "(#{price} руб. за #{coefficient} #{unit}). "
      result += "Кол-во: #{coefficient} #{unit}. "
      # result += "На складе: #{product_offer.quantity}. "
    end
    result
  end

  def price

    discount_coef = 100.00

    if product_offer
      lv_product = product_offer.product
      
      # Перебираем все родительские категории:
      lv_product.category.ancestors.each do |category|
        if category.discount.present?
          discount_coef = (100 - category.discount.amount)
        end
      end

      # Проверяем скидку на категорию в которой сейчас продукт
      if lv_product.category.discount.present?
        discount_coef = (100 - lv_product.category.discount.amount)
      end

      # Проверяем есть ли скидка на все:
      discount = Discount.find_by(all_products: true)
      if discount
        discount_coef = (100 - discount.amount)
      end

      # Проверяем есть ли скидка на сам товар отдельно
      if lv_product.discount.present?
        discount_coef = (100 - lv_product.discount.amount)
      end
    end

    super * ( discount_coef.to_f / 100.00 )

  end

  def old_price
    # price / (100 - product_offer.product.discount.amount)
  end

end
