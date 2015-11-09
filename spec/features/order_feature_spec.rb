require 'rails_helper'

feature "Заказ" do

  background do
    # 1. Предистория
    @category = create(:category, :with_children, :with_product)
    @order_attrs = attributes_for(:order)
    @user = log_in()
    @coupon = create(:coupon)

    p "Capybara.current_driver = #{Capybara.current_driver}"
    p "Capybara.default_driver = #{Capybara.default_driver}"
    p "Capybara.javascript_driver = #{Capybara.javascript_driver}"

    visit root_path
    # Заполняем корзину
    fill_cart @category

    # Нажимаем на просмотр корзины
    visit_cart
    @cart = Cart.first
  end

  scenario "Оформляем заказ" do
    total_price_before = @cart.total_price(true)
    doing_order()

    order = Order.first
    expect(order[:name]).to eq @order_attrs[:name]
    expect(order[:address]).to eq @order_attrs[:address]
    expect(order[:email]).to eq @order_attrs[:email]
    expect(order.total_price(true)).to eq total_price_before
  end

  scenario "Оформляем заказ с купоном", js: true do
    # Вводим созданный купон:
    fill_in 'code', with: @coupon[:code]
    click_button 'Применить купон'
    # Cart.first.coupon = @coupon
    expect(page).to have_content('15%')

    total_price_before = @cart.total_price(true)
    doing_order()

    order = Order.first
    expect(order[:name]).to eq @order_attrs[:name]
    expect(order[:address]).to eq @order_attrs[:address]
    expect(order[:email]).to eq @order_attrs[:email]
    expect(order.coupon).to eq @coupon
    expect(order.total_price(true)).to eq total_price_before
  end

  scenario "Формляем заказ с доставкой", js: true do
    click_button 'Посчитать стоимость доставки'
    choose('price_of_shipping', match: :first)
    click_button 'Выбрать'
    expect(Cart.first.price_of_shipping).not_to eq(0.00)
    expect(Cart.first.kind_of_shipping).not_to eq('')
    price_of_shipping_before = Cart.first.price_of_shipping
    kind_of_shipping_before = Cart.first.kind_of_shipping
    doing_order()

    order = Order.first
    expect(order.price_of_shipping).to eq price_of_shipping_before
    expect(order.kind_of_shipping).to eq kind_of_shipping_before
  end

  def doing_order
    click_link 'Оформить заказ'
    fill_form_for_order @order_attrs
    click_button 'Разместить заказ'
  end

end