# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :category do
    sequence(:title){|n| "Category title #{n}"}
    published true
    sequence(:one_ass_id){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a"}

    trait :with_children do
      after(:create) do |category|
        create_list(:category, 4, :with_product, parent: category)
      end
    end

    trait :with_product do
      after(:create) do |category|
        category.products << create(:product)
      end
    end

  end

  factory :cart do
    after(:create) do |cart|
      cart.line_items << create(:line_item)
    end
  end

  factory :order do
    sequence(:name){|n| "My name is nam#{n}"}
    address 'Москва'
    sequence(:email){|n| "mail#{n}@mail.ru"}
    trait :with_line_items do
      after(:create) do |order|
        order.line_items << create(:line_item)
      end
    end
  end

  factory :line_item do
    association :product
  end


  factory :import_one_ass do
  end

  factory :project do
    title 'project name'
    hostname 'hostname'
  end

  factory :product do
    sequence(:one_ass_id){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a"}
    sequence(:title){|n| "Product title #{n}"}
    price 999
    description "Описание товара"
    sequence(:article){|n| "44#{n}325"}
    published true
    after(:create) do |product|
      offer_one_ass_id = "#{product.one_ass_id}#bd72d8f9-3bc-11d9-648a-00112f43529a"
      product.product_offers << create(:product_offer, one_ass_id: offer_one_ass_id)
      product.images << create(:image)
    end
  end

  factory :characteristic_name do
    sequence(:title){|n| "Characteristic name #{n}"}
    sequence(:one_ass_id){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a"}
    after(:create) do |characteristic_name|
      characteristic_name.characteristic_values << create(:characteristic_value)
    end
  end

  factory :characteristic_value do
    sequence(:value){|n| "value #{n}"}
    sequence(:one_ass_id){|n| "bd72d3f9-#{n}bc-11d9-#{n}43a-00112f43529a"}
  end

  factory :coupon do
    user nil
    amount 15
    sequence(:code){|n| "CODENUMBER#{n}"}
    valid_till ""
    permanent true
    cart nil
    used_at ""
    order nil
  end

  factory :image do
    sequence(:one_ass_path){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a"}
  end


  factory :user do
    sequence(:email){|n| "email_#{n}@mail.ru"}
    sequence(:full_name){|n| "name_#{n}"}
    password 'current_password'
    password_confirmation 'current_password'
  end

  factory :product_offer do
    sequence(:one_ass_id){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a#bd43d2f9-#{n}bc-11d9-#{n}46a-00112f43529a"}
    quantity 197
    after(:create) do |product_offer|
      product_offer.offer_prices << create(:offer_price)
      product_offer.offer_characteristics << create(:offer_characteristic)
    end
  end

  factory :offer_price do
    sequence(:one_ass_price_type_id){|n| "bd72d8f9-#{n}bc-11d9-#{n}48a-00112f43529a"}
    sequence(:price){|n| "#{n + 1473.00}"}
    currency 'руб'
    unit 'шт'
    coefficient 1
  end

  factory :offer_characteristic do
    title "Размер"
    sequence(:value){|n| "#{n}"}
  end

  # factory :user do
  #   sequence(:email){|n| "mail#{n}@team.dev"}
  #   password "Password123123"
  #   password_confirmation "Password123123"

  #   association :person

  #   Role::ROLES.each do |role_title|
  #     trait role_title.to_sym do
  #       after(:create) do |user|
  #         user.add_role(role_title)
  #       end
  #     end
  #   end

  #   # trait :deppkind do
  #   #   association :role, title: 'deppkind'
  #   # end
  #   # trait :deppkind do
  #   #   association :role, title: 'deppkind'
  #   # end
  # end

  # # factory :attachment do
  # #   sequence(:title){|n| "Skyleader #{n} Attachment"}
  # #   attach "#{Rails.root}/spec/support/starter_button.pdf"
  # # end

  # factory :post do
  #   sequence(:title){|n| "Post #{n} Title"}
  #   sequence(:body){|n| "Post #{n} Title"}
  #   published true
  #   trait :public do
  #     visibility 'public'
  #   end
  #   trait :patriot do
  #     visibility 'team'
  #   end
  #   trait :team do
  #     visibility 'team'
  #   end
  # end

  # factory :role do
  #   sequence(:title){|n| "role#{n}"}
  # end

  # factory :person do
  #   sequence(:first_name){|n| "first_name#{n}"}
  #   sequence(:last_name){|n| "last_name#{n}"}
  #   sequence(:height){|n| "height#{n}"}
  #   sequence(:weight){|n| "weight#{n}"}
  #   sequence(:bdate){|n| "bdate#{n}"}
  # end

  # factory :roster do
  #   sequence(:season){|n| "#{n*3}"}
  # end

end