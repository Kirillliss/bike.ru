require 'rails_helper'

feature "Просмотр галвной страницы" do

  background do
    # 1. Предистория
    visit root_path
  end

  scenario "Просмотр главной страницы импорта" do
    # 2. взаимодействие пользователя с системой
    # 3. проверяем успешность выполнения этого сценария
    page.should have_content('Категории товаров')
    page.should have_content('Выгодное предложение')
    page.should have_content('Хиты продаж')
    page.should have_content('Уцененные товары')
  end

  scenario "TEST" do
    offer = create :product_offer
    expect(ProductOffer.count).to eq 1
    expect(OfferPrice.count).to eq 1
    expect(OfferCharacteristic.count).to eq 1

    ProductOffer.delete_all
    expect(ProductOffer.count).to eq 0
    expect(OfferPrice.count).to eq 1
    expect(OfferCharacteristic.count).to eq 1

    expect(OfferPrice.first.id).not_to eq nil
    expect(OfferCharacteristic.first.id).not_to eq nil

  end

end
