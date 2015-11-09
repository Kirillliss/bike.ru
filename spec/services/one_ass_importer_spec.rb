require 'rails_helper'

feature 'Процессор' do

  # Мой блок - я его и закончу
  feature 'Проверка категорий' do

    let(:random_categories_count){rand(100)}
    let(:processor){ OneAssProcessor.new }

    background do
      @project = create(:project)
    end

    scenario 'Импорт категорий из XML файла' do
      # setup

      # передаем генерируемый xml в процессор на какое-то количество random_categories_count категорий
      processor.xml = generate_categories_xml(random_categories_count)
      # execute
      # парсим и сохраняем в базу
      processor.process_categories!
      # verify
      # категорий в классе должно быть столько же сколько нагенерили в xml
      expect(processor.categories_array.count).to eq random_categories_count
      # категорий в  базе должно быть столько же сколько нагенерили в xml
      expect(Category.count).to eq random_categories_count
    end

    scenario 'Должен создать из блока xml объект в массиве' do
      # setup
      category_attrs = attributes_for(:category)
      category_xml = generate_category_xml(category_attrs[:one_ass_id], category_attrs[:title])

      # execute
      processor.extract_category(category_xml)

      # verify
      expect(processor.categories_array.count).to eq 1
      expect(processor.categories_array.first[:title]).to eq category_attrs[:title]
      expect(processor.categories_array.first[:one_ass_id]).to eq category_attrs[:one_ass_id]
    end

    scenario 'Если была уже одна категория, и прилетела новая то должен обновить и создать только одну' do
      category_attrs = attributes_for(:category)
      category = create(:category)

      expect(Category.count).to eq 1

      category_xml = generate_category_xml(category_attrs[:one_ass_id], category_attrs[:title])
      exist_category_xml = generate_category_xml(category.one_ass_id, category.title)

      processor.extract_category(category_xml)
      processor.extract_category(exist_category_xml)
      processor.store_extracted_categories!

      expect(Category.count).to eq 2

    end

    scenario 'Должен создать из блока Группа xml объект в базе' do
      # setup
      category_attrs = attributes_for(:category)
      category_xml = generate_category_xml(category_attrs[:one_ass_id], category_attrs[:title])

      # execute
      processor.extract_category(category_xml)
      processor.store_extracted_categories!

      # verify
      expect(Category.count).to eq 1
      expect(Category.first.title).to eq category_attrs[:title]
      expect(Category.first.one_ass_id).to eq category_attrs[:one_ass_id]
    end

    scenario 'Должен создать из блока xml со вложенными группами объекты с дочерними группами в массиве и базе' do
      # pending 'Тоже не работает пока еще'
      categories_array = []
      5.times do
        children = []
        rand(3).times do
          attrs = attributes_for(:category)
          sub_children = []
          rand(3).times do
            sub_children << attributes_for(:category)
          end
          children << {
            one_ass_id: attrs[:one_ass_id],
            title: attrs[:title],
            children: sub_children
          }
        end
        attrs2 = attributes_for(:category)
        categories_array << {
          one_ass_id: attrs2[:one_ass_id],
          title: attrs2[:title],
          children: children
        }
      end
      processor.xml = generate_categories_from_array(categories_array)
      # puts processor.xml
      processor.process_categories!
      expect(Category.roots.count).to eq categories_array.count
      categories_array.each do |category_attr|
        matching_category = Category.find_by(one_ass_id: category_attr[:one_ass_id])
        expect(matching_category.title).to eq category_attr[:title]
        if category_attr[:children].present?
          expect(matching_category.children.count).to eq category_attr[:children].count
        end
      end
    end
  end

  # ПАША ЭТО Твой блок заданий к реализации (это тупая копипаста вышеописанного)
  feature 'Импорт товаров' do

    let(:processor){ OneAssProcessor.new }

    background do
      # setup
      @product_attrs = attributes_for(:product)
      @product_attrs[:category_one_ass_id] = "bd11d8f9-2bc-11d9-148a-00112f43529a"
      @product_attrs[:producer_one_ass_id] = "bd22d8f9-2bc-22d9-148a-00112f43529a"
      @product_attrs[:producer_name] = "Название производителя"
      @product_attrs[:images_one_ass_id] ||= []
      @product_attrs[:images_one_ass_id] << "bd33d8f9-2bc-22d9-148a-00112f43529a"
      @product_attrs[:product_characteristics] ||= []
      @product_attrs[:product_characteristics] << { characteristic_name_one_ass_id: "bd44d8f9-2bc-22d9-148a-00112f43529a",
                                                    characteristic_value_one_ass_id: "bd55d8f9-2bc-22d9-148a-00112f43529a"
                                                  }

      characteristic_name = create(:characteristic_name)
      CharacteristicName.first.update_attribute('one_ass_id', @product_attrs[:product_characteristics].first[:characteristic_name_one_ass_id])
      CharacteristicValue.first.update_attribute('one_ass_id', @product_attrs[:product_characteristics].first[:characteristic_value_one_ass_id])

      @product_xml = generate_product_xml(@product_attrs)
      #File.open('tmp/import.xml', 'r') { |f| @product_xml = Nokogiri::XML(f) }

    end

    scenario 'Должен создать из переданного блока Товар xml объект в массиве' do
      # execute
      processor.extract_product(@product_xml)

      # verify
      expect(processor.products_array.count).to eq 1
      prod = processor.products_array.first
      expect(prod[:one_ass_id]).to eq @product_attrs[:one_ass_id]
      expect(prod[:title]).to eq @product_attrs[:title]
      expect(prod[:category_one_ass_id]).to eq @product_attrs[:category_one_ass_id]
      expect(prod[:article]).to eq @product_attrs[:article]
      expect(prod[:description]).to eq @product_attrs[:description]
      expect(prod[:producer_one_ass_id]).to eq @product_attrs[:producer_one_ass_id]
      expect(prod[:producer_name]).to eq @product_attrs[:producer_name]
      expect(prod[:images_one_ass_id]).to eq @product_attrs[:images_one_ass_id]
      expect(prod[:product_characteristics]).to eq @product_attrs[:product_characteristics]

    end

    scenario 'Должен создать из блока Товар xml объект в базе' do
      # execute
      processor.extract_product(@product_xml)
      processor.store_extracted_products!

      # verify
      expect(Product.count).to eq 1
      prod = Product.first
      expect(prod.one_ass_id).to eq @product_attrs[:one_ass_id]
      expect(prod.title).to eq @product_attrs[:title]
      expect(prod.category).to eq Category.find_by(one_ass_id: @product_attrs[:category_one_ass_id])
      expect(prod.article).to eq @product_attrs[:article]
      expect(prod.description).to eq @product_attrs[:description]
      expect(prod.producer).to eq Producer.find_by(one_ass_id: @product_attrs[:producer_one_ass_id])
      expect(prod.images).to eq Image.where(one_ass_path: @product_attrs[:images_one_ass_id])
      expect(prod.product_characteristics.count).to eq(1)

    end

    scenario 'Если был один товар, и прилетел новый то должен обновить текущий и создать только один новый товар' do
      # Создаем товар
      product = create(:product)
      expect(Product.count).to eq 1

      # Генерируем XML:
      exist_product_xml = generate_product_xml(product)

      processor.extract_product(@product_xml)
      processor.extract_product(exist_product_xml)
      processor.store_extracted_products!

      expect(Product.count).to eq 2

    end

    scenario 'Должен создать все переданные товары в базе' do
      category_and_product_count = 5
      product_count = category_and_product_count*category_and_product_count

      # передаем генерируемый xml в процессор на какое-то количество товаров
      processor.xml = generate_categories_xml(category_and_product_count, true)
      # execute
      # парсим и сохраняем в базу
      processor.process_products!
      # verify
      # категорий в классе должно быть столько же сколько нагенерили в xml
      expect(processor.products_array.count).to eq product_count
      # категорий в  базе должно быть столько же сколько нагенерили в xml
      expect(Product.count).to eq product_count
    end

  end

  # То же самое по оферам делаешь, только тут еще надо сделать копипасту четырех минимум фич
  feature 'Импорт офферов' do

    let(:processor){ OneAssProcessor.new }

    background do
      # setup
      @product_offer_attrs = params_product_offer

      # генерируем XML
      @product_offer_xml = generate_product_offer_xml(@product_offer_attrs)
      # File.open('tmp/offers.xml', 'r') { |f| @product_offer_xml = Nokogiri::XML(f) }

      # Создаем продукт чтобы к нему цеплялись предложения
      @product = create(:product, one_ass_id: @product_offer_attrs[:one_ass_id].split('#').first)
      ProductOffer.destroy_all
    end

    scenario 'Должен создать из переданного блока Офер xml объект в массиве' do

      # execute
      processor.extract_offer(@product_offer_xml)

      # verify
      expect(ProductOffer.count).to eq 0

      expect(processor.offers_array.count).to eq 1
      expect(processor.offers_array.first[:offer_prices].count).to eq 1
      expect(processor.offers_array.first[:offer_characteristics].count).to eq 1

      expect(processor.offers_array.first[:one_ass_id]).to eq @product_offer_attrs[:one_ass_id]
      expect(processor.offers_array.first[:quantity]).to eq @product_offer_attrs[:quantity]
      expect(processor.offers_array.first[:offer_prices]).to eq @product_offer_attrs[:offer_prices]
      expect(processor.offers_array.first[:offer_characteristics]).to eq @product_offer_attrs[:offer_characteristics]
    end

    scenario 'Должен создать из блока Офер xml объект в базе' do
      # execute
      processor.extract_offer(@product_offer_xml)
      processor.store_extracted_offers!

      # verify
      expect(processor.offers_array.count).to eq 1
      expect(ProductOffer.count).to eq 1
      expect(OfferPrice.count).to eq 1
      expect(OfferCharacteristic.count).to eq 1

      product_offer = ProductOffer.first
      expect(product_offer.one_ass_id).to eq @product_offer_attrs[:one_ass_id]
      expect(product_offer.quantity).to eq @product_offer_attrs[:quantity]

      @product_offer_attrs[:offer_characteristics].first.each do |key, value|
        expect(product_offer.offer_characteristics.first[key]).to eq value
      end
      @product_offer_attrs[:offer_prices].first.each do |key, value|
        expect(product_offer.offer_prices.first[key]).to eq value
      end
      # Проверяем привязку оффера к продукту
      expect(@product.product_offers.first). to eq product_offer
    end

    scenario 'Если был один Офер, и прилетел новый то должен обновить текущий и создать только один новый товар' do

      product_offer_new = create(:product_offer)
      expect(ProductOffer.count).to eq 1
      product_offer_new_xml = generate_product_offer_xml(product_offer_new)

      processor.extract_offer(product_offer_new_xml)
      processor.extract_offer(@product_offer_xml)
      processor.store_extracted_offers!

      expect(ProductOffer.count).to eq 2

    end

    scenario 'Должен создать все переданные офферы в базе' do

      count = 5

      # передаем генерируемый xml в процессор на какое-то количество товаров
      processor.xml = generate_product_offers_xml(count)
      ProductOffer.delete_all
      # execute
      # парсим и сохраняем в базу
      processor.process_offers!
      # verify
      # категорий в классе должно быть столько же сколько нагенерили в xml
      expect(processor.offers_array.count).to eq count
      # категорий в  базе должно быть столько же сколько нагенерили в xml
      expect(ProductOffer.count).to eq count
    end

    def params_product_offer
      product_offer_attrs = attributes_for(:product_offer)
      offer_price_attrs = attributes_for(:offer_price)
      offer_characteristic_attrs = attributes_for(:offer_characteristic)

      result = {}
      result[:one_ass_id] = product_offer_attrs[:one_ass_id]
      result[:quantity] = product_offer_attrs[:quantity]

      result[:offer_characteristics] = []
      result[:offer_characteristics] << { title: offer_characteristic_attrs[:title],
                                          value: offer_characteristic_attrs[:value]
                                        }

      result[:offer_prices] = []
      result[:offer_prices] << { one_ass_price_type_id: offer_price_attrs[:one_ass_price_type_id],
                                 price: offer_price_attrs[:price].to_f,
                                 currency: offer_price_attrs[:currency],
                                 unit: offer_price_attrs[:unit],
                                 coefficient: offer_price_attrs[:coefficient]
                               }

      result
    end

  end

  feature 'Импорт свойств и значений' do

    let(:processor){ OneAssProcessor.new }

    background do
      # setup
      @property_and_values_attrs = params_property_and_values
      # генерируем XML
      # @property_and_values_xml = generate_property_and_values_xml(@product_offer_attrs)
      # File.open('tmp/offers.xml', 'r') { |f| @product_offer_xml = Nokogiri::XML(f) }

    end

    scenario 'Должен создать из переданного блока Свойств и значений xml объект в массиве' do

      # execute
      processor.extract_offer(@product_offer_xml)


    end

    def params_property_and_values
      result = {}
      name_attrs = attributes_for(:characteristic_name)
      value_attrs = attributes_for(:characteristic_value)

      result[:one_ass_id] = name_attrs[:one_ass_id]
      result[:title] = name_attrs[:title]

      result[:values] = []
      result[:values] << {
                           one_ass_id: value_attrs[:one_ass_id],
                           value: value_attrs[:value]
                         }

      result

    end

  end

  # Когда все сделаешь это тоже тебе
  feature 'Импорт изображений' do

    scenario 'Загрузка всех файлов' do
      processor = OneAssProcessor.new
      create(:project)
      doc_import = Nokogiri::XML(File.open("#{Rails.root}/spec/support/data/import.xml").read)
      doc_offers = Nokogiri::XML(File.open("#{Rails.root}/spec/support/data/offers.xml").read)
      processor.xml = doc_import.to_xml
      processor.process_categories!
      processor.process_properties_and_values!
      processor.process_products!
      processor.xml = doc_offers.to_xml
      processor.process_offers!

      p "Product.count = #{Product.count}"
      p "ProductOffer.count = #{ProductOffer.count}"
      processor.products_array.each do |product|
        p product[:one_ass_id]
        first = false
        second = false
        processor.offers_array.each do |offer|
          if offer[:one_ass_id].split('#').first == product[:one_ass_id]
            first = true
          elsif offer[:one_ass_id].split('#').second == product[:one_ass_id]
            second =  true
          end
        end
        p "first: #{first}" if first
        p "second: #{second}" if second
      end

      expect(Product.count).not_to eq(0)
    end
  end
  # Пока не понял как идет импорт изображений

  feature 'Проверяем как сохраняются посты файлов из 1C' do
    scenario 'Проверка import.xml' do
      # строка которую мы постим - это содеражние нашего XML
      xml_body_string = File.open("#{Rails.root}/spec/support/data/import.xml").read

      # эта шляпа постит файл как 1С, передавать туда надо строку и что шлем
      post_like_one_ass(xml_body_string, 'import.xml')

      # проверяем
      doc = Nokogiri::XML(ImportOneAss.first.import_xml)

      expect(doc.xpath('//Товары/Товар').first.xpath('Наименование').text).to eq('Стол обеденный IKEA IMPORT')
    end

    scenario 'Проверка что пришел невалидный файл до сохранения' do
      import = ImportOneAss.new
      import.attach_xml!('<Джигурда/>', 'import.xml')
      expect(import.errors[:import_xml].first).to eq('Невалидный import.xml')
    end

    scenario 'Проверка что пришел невалидный файл до сохранения' do
      import = ImportOneAss.new
      import.attach_xml!('<Джигурда/>', 'offers.xml')
      # проверяем
      expect(import.errors[:offers_xml].first).to eq('Невалидный offers.xml')
      # doc = Nokogiri::XML(first_import.import.read)
    end

    scenario 'Проверка offers.xml' do
      # строка которую мы постим - это содеражние нашего XML
      xml_body_string = File.open("#{Rails.root}/spec/support/data/offers.xml").read

      # эта шляпа постит файл как 1С, передавать туда надо строку и что шлем
      post_like_one_ass(xml_body_string, 'offers.xml')

      # проверяем
      doc = Nokogiri::XML(ImportOneAss.first.offers_xml)

      expect(doc.xpath('//Предложения/Предложение').first.xpath('Наименование').text).to eq('Стол обеденный IKEA OFFERS')

    end

  end

end

