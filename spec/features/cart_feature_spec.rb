require 'rails_helper'

feature "Корзина" do

  background do
    # 1. Предистория
    @category = create(:category, :with_children)
    visit root_path
  end

  scenario "Просмотр пустой корзины" do
    # 2. взаимодействие пользователя с системой
    visit_cart
    # 3. проверяем успешность выполнения этого сценария
    page.should have_content 'Корзина'
    page.should have_content 'Итого'
    page.should have_link 'Оформить заказ'
  end

  scenario "Просмотр корзины с товаром" do
    # 2. взаимодействие пользователя с системой
    product = fill_cart @category
    # Нажимаем на просмотр корзины
    visit_cart
    # 3. проверяем успешность выполнения этого сценария
    page.should have_content 'Корзина'
    page.should have_link product.title
  end

end