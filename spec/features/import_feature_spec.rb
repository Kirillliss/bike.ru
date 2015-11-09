require 'rails_helper'

feature "Просмотр категории организации" do

  background do
    # 1. Предистория
    visit admin_root_url

    # Нажимаем 'Настрйоки/Загрузка из CSV'
    within('ul#settings.dropdown-menu') do
      click_link 'Загрузка из CSV'
    end

    @producer = Producer.create(title: "Оптовик Затейник")
    @curr_url = "https://skibikeru.s3.amazonaws.com/uploads/import/file_xls/7/file_for_upload.csv"
  end

  scenario "Просмотр главной страницы импорта" do
    # 3. проверяем успешность выполнения этого сценария
    expect(page).to have_content "Список импортов"
  end

  context "Создание нового импорта" do

    background do
      # 1. Предистория
      click_link 'Новый импорт'

      fill_form_create_import
    end

    scenario "Создаем новый импорт и смотрим на соотношение полей" do
      # 3. проверяем успешность выполнения этого сценария
      expect(page).to have_content "Поля из файла"
      expect(page).to have_content "Поля базы данных"
    end

    scenario "Выбираем соотношение полей" do
      # 2. взаимодействие пользователя с системой
      header_row = ImportFromExcel.new(@curr_url).header_row
      header_row.each { |h| select(h, :from => "hash_from_form[#{h}]") }
      click_button('Готово')
    end

  end

  def fill_form_create_import
      file_name = 'file_for_upload.csv'
      attach_file 'import[file_xls]', 'tmp/'+file_name
      select(@producer.title, :from => 'import[producer_id]')
      click_button('Импортировать')
  end

end