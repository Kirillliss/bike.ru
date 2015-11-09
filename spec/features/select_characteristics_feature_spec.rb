require 'rails_helper'

feature "Просмотр категории организации" do

    background do
      # 1. Предистория
      @category = create(:category, :with_children)
      visit root_path
    end

    scenario "Выбор характеристик" do
      # Выбираем категорию
      click_link @category.children.last.title
      # Нажимаем на просмотр товара:
      product = @category.children.last.products.last
      click_link product.title

      title_product = product.product_offers.first.offer_prices.first.title
      select(title_product, :from => 'offer')
      click_button_in_cart

      expect(Cart.first.line_items.first.product.product_offers.first.offer_prices.first.title).to eq(title_product)

    end

end