class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  has_one :coupon

  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end

  def add_special_offer(special_offer_id)
    current_item = line_items.find_by(special_offer_id: special_offer_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(special_offer_id: special_offer_id)
    end
    current_item
  end

  def total_price (with_coupon = false)
    result = line_items.to_a.sum { |item| item.total_price }
    if with_coupon
      coupon ? result = result / 100 * (100 - coupon.amount) : nil
    end
    result
  end

end
