require 'rails_helper'

feature "Регистрация и вход в систему" do

  background do
    # 1. Предистория
    visit root_path
    click_link 'Войти'
    @hesh_for_user = { full_name: "Иванов Иван Иванович", phone: "+79507777777", email: "test@gmail.com", password: "Cur_pass_777" }
  end

  context "Создание новой сессии для созданного пользователя" do

    background do
      @user = create(:user)
    end

    scenario "Удачный вход" do
      # 2. взаимодействие пользователя с системой
      within('form.form-stacked') do
        fill_in 'user[email]', :with => @user[:email]
        fill_in 'user[password]', :with => "current_password"
        click_button 'Войти'
      end
      # 3. проверяем успешность выполнения этого сценария
      page.should have_link('Выйти')
    end

    scenario "Неверный пароль" do
      # 2. взаимодействие пользователя с системой
      within('form.form-stacked') do
        fill_in 'user[email]', :with => @user[:email]
        fill_in 'user[password]', :with => "uncurrent_password"
        click_button 'Войти'
      end
      # 3. проверяем успешность выполнения этого сценария
      page.should_not have_link('Выйти')
    end

  end

  scenario "Создание нового пользователя" do
    # 2. взаимодействие пользователя с системой
    within('form.new_user') do
      fill_in 'user[full_name]', :with => @hesh_for_user[:full_name]
      fill_in 'user[phone]', :with => @hesh_for_user[:phone]
      fill_in 'user[email]', :with => @hesh_for_user[:email]
      fill_in 'user[password]', :with => @hesh_for_user[:password]
      fill_in 'user[password_confirmation]', :with => @hesh_for_user[:password]
      click_button('Зарегистрироваться')
    end
    # 3. проверяем успешность выполнения этого сценария
    page.should have_link('Выйти')
  end

end