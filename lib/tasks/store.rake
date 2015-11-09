namespace :clear do
# rake clear

  task product_offers: :environment do

    puts "---ProductOffer = #{ProductOffer.count}---"

    product_ids = Product.pluck('id')
    puts "product_ids = #{product_ids.count}"

    product_offer_current_ids = ProductOffer.where(product_id: product_ids).pluck('id')
    puts "product_offer_current_ids = #{product_offer_current_ids.count}"

    products_offer_to_kill_ids = ProductOffer.where.not(id: product_offer_current_ids).pluck('id')
    puts "products_offer_to_kill_ids = #{products_offer_to_kill_ids.count}"

    destroy_all ActiveRecord::Base::ProductOffer, products_offer_to_kill_ids

    puts "---ProductOffer = #{ProductOffer.count}---"
  end

  task offer_prices: :environment do

    puts "---OfferPrice = #{OfferPrice.count}---"

    product_offer_ids = ProductOffer.pluck('id')
    puts "product_offer_ids = #{product_offer_ids.count}"

    offer_price_current_ids = OfferPrice.where(product_offer_id: product_offer_ids).pluck('id')
    puts "offer_price_current_ids = #{offer_price_current_ids.count}"

    offer_price_to_kill_ids = OfferPrice.where.not(id: offer_price_current_ids).pluck('id')
    puts "offer_price_to_kill_ids = #{offer_price_to_kill_ids.count}"

    destroy_all ActiveRecord::Base::OfferPrice, offer_price_to_kill_ids

    puts "---OfferPrice = #{OfferPrice.count}---"

  end

  task offer_characteristics: :environment do

    puts "---OfferCharacteristic = #{OfferCharacteristic.count}---"

    product_offer_ids = ProductOffer.pluck('id')
    puts "product_offer_ids = #{product_offer_ids.count}"

    offer_characteristic_current_ids = OfferCharacteristic.where(product_offer_id: product_offer_ids).pluck('id')
    puts "offer_characteristic_current_ids = #{offer_characteristic_current_ids.count}"

    offer_characteristic_to_kill_ids = OfferCharacteristic.where.not(id: offer_characteristic_current_ids).pluck('id')
    puts "offer_characteristic_to_kill_ids = #{offer_characteristic_to_kill_ids.count}"

    destroy_all ActiveRecord::Base::OfferCharacteristic, offer_characteristic_to_kill_ids

    puts "---OfferCharacteristic = #{OfferCharacteristic.count}---"

  end

  def destroy_all(model, to_kill_ids = [])
    count_for_slice = 1000
    to_kill_ids.each_slice(count_for_slice) do |group_ids|
      model.where(id: group_ids).destroy_all
      puts "Удалилось #{count_for_slice} записей из #{model.to_s}"
    end
  end

end

