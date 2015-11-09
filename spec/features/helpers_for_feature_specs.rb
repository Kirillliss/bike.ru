def visit_cart
  click_link 'link_to_show_cart' # по id
end

def visit_wishlist
  click_link 'link_to_show_wishlist'
end

def show_product category
  find('#link_catalog').hover if Capybara.current_driver == :selenium
  # Выбираем категорию
  click_link category.children.last.title
  # Нажимаем на просмотр товара:
  product = category.children.last.products.last
  click_link product.title
  product
end

def fill_wishlist category
  # просмотр товара:
  product = show_product category
  click_button_in_wishlist
  product
end

def fill_cart category
  # просмотр товара:
  product = show_product category
  # Добавляем товар в корзину
  click_button_in_cart
  product
end

def fill_form_for_order(attrs = {})
  fill_in 'order[name]', :with => attrs[:name]
  fill_in 'order[address]', :with => attrs[:address]
  fill_in 'order[email]', :with => attrs[:email]
end

def click_button_in_cart
  within('.catalog-single') do
    click_button 'В корзину'
  end
end

def click_button_in_wishlist
  within('.catalog-single') do
    click_link 'Сравнить'
  end
end

def log_in
  visit root_path
  click_link 'Войти'
  user_attrs = attributes_for(:user)
  user = create(:user, user_attrs)
  within('form.form-stacked') do
    fill_in 'user[email]', :with => user_attrs[:email]
    fill_in 'user[password]', :with => user_attrs[:password]
    click_button 'Войти'
  end
  user
end
