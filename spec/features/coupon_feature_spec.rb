require 'rails_helper'

feature "Купон" do

  background do
    @coupon = create(:coupon)
    @user = create(:user)
    @category = create(:category, :with_children)

    p User.count
    visit root_path
    click_link 'Войти'
    log_in(@user)
    save_and_open_page
    fill_cart @category
    visit_cart
  end

  scenario "Ввод верного кода купона", js: true do
    fill_in 'code', :with => @coupon.code
    click_button 'Применить купон'
    # Проверяем что купон действует на заказ:
    # Ваша скидка составляем 20%
    # Итого по заказу 621.60 руб (с учетом скидки)

    # Кликаем Оформить заказ и проверяем правильность
    # Со скидкой купона 621.60 руб.
  end

  def log_in(user)
    within('form.form-stacked') do
      fill_in 'user[email]', :with => @user.email
      fill_in 'user[password]', :with => 'current_password'
      click_button 'Войти'
    end
  end

  # def visit_cart
  #   within('div.cart-dropdown') do
  #     click_link 'В корзину'
  #   end
  # end

  # def fill_cart category
  #   # Выбираем категорию
  #   click_link category.children.last.title
  #   # Нажимаем на просмотр товара:
  #   click_link category.children.last.products.last.title
  #   # Добавляем товар в корзину
  #   within('.catalog-single') do
  #     click_link 'В корзину'
  #   end
  # end

end