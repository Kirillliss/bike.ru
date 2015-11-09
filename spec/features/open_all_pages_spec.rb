require 'rails_helper'

feature "Открытие всех страниц сайта" do

  context "Зарегистрированный пользователь" do

    background do
      @category = create(:category, :with_children)
      @user = log_in()
      visit root_path
    end

    scenario "Просмотр категорий" do
      title = @category.children.last.title
      click_link title
      within('h2.with-sorting') do
        expect(page).to have_content title
      end
    end

    scenario "Заполнение корзины -> Корзина -> Оформление заказа", js: true do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.deliveries = []

      fill_cart @category
      visit_cart
      choose 'price_of_shipping', match: :prefer_exact
      click_link 'Оформить заказ'
      expect(page).to have_content 'Оформление заказа'
      fill_in 'order[address]', with: 'Москва'
      click_button 'Разместить заказ'
      expect(Order.count).to eq(1)
      expect(ActionMailer::Base.deliveries.count).to eq(2)

      ActionMailer::Base.deliveries.clear
    end

    # scenario "Просмотр листа сравнений(виш лист)" do
    #   fill_wishlist @category
    #   visit_wishlist
    #   expect(page).to have_content 'Сравнение товаров'
    # end

    scenario "Просмотр контактов" do
      click_link 'Контакты'
      expect(page).to have_content 'Наши контакты'
    end

    scenario "Просмотр информации О нас" do
      click_link 'О нас'
      expect(page).to have_content 'О нас'
    end

  end

  context "Анонимный пользователь" do

    background do
      @category = create(:category, :with_children)
      visit root_path
    end

    scenario "Просмотр категорий" do
      title = @category.children.last.title
      click_link title
      expect(page).to have_content title
    end

    scenario "Просмотр контактов" do
      click_link 'Контакты'
      expect(page).to have_content 'Наши контакты'
    end

    scenario "Просмотр информации О нас" do
      click_link 'О нас'
      expect(page).to have_content 'О нас'
    end

  end

end