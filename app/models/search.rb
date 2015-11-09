class Search < ActiveRecord::Base

  belongs_to :producer

  belongs_to :category

  def filter_products(products)

    products = products.filter_price price_from, price_to
    products = products.filter_producer producer_id

    products

  end

end
