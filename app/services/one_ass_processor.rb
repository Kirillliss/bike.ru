class OneAssProcessor
  attr_accessor :xml
  attr_accessor :categories_array
  attr_accessor :products_array
  attr_accessor :offers_array
  attr_accessor :properties_and_values_array

  STR = '================================================='

  def initialize
    @categories_array = []
    @products_array = []
    @offers_array = []
    @properties_and_values_array = []
  end

  def process_categories!
    puts STR
    puts 'process_categories! (НАЧАЛО)'
    puts STR
    doc = Nokogiri::XML(xml)
    doc.xpath("//Классификатор/Группы/Группа").each do |group|
      extract_category(group.to_xml)
    end
    store_extracted_categories!
    puts STR
    puts 'process_categories! (КОНЕЦ)'
    puts STR
  end

  # извлекаем категорию из xml тега Группа
  def extract_category(category_xml)
    @categories_array << extract_from_xml(category_xml)
  end

  def extract_from_xml(category_xml, extract = false)
    group = Nokogiri::XML(category_xml).xpath('Группа')
    group_id = group.xpath("Ид").text
    group_name = group.xpath("Наименование").text
    children_array = []
    group.xpath('Группы/Группа').each do |child|
      children_array << extract_from_xml(child.to_xml, true)
    end
    { one_ass_id: group_id, title: group_name, children: children_array }
  end

  # сохраняем все категории в базу из собранного массива
  def store_extracted_categories!
    @categories_array.each do |category_attrs|
      store_category!(category_attrs)
    end
  end

  def store_category!(category_attrs, parent_category = false)
    category = Category.where(one_ass_id: category_attrs[:one_ass_id]).first_or_initialize
    category.title = category_attrs[:title]
    category.parent = parent_category if parent_category
    category.published = true
    pr = Project.first
    category.projects << pr unless category.projects.include? pr
    category.save
    category_attrs[:children].each do |chid_attrs|
      store_category!(chid_attrs, category)
    end
  end

  # Метод который был ранее в классе Product
  # def self.extract_group(group_xml, scope, parent = nil)
  #   group = Nokogiri::XML(group_xml).xpath('/Группа')
  #   nested_groups = group.xpath('Группы/Группа')
  #   puts "\t"*scope + "#{group_name}:#{group_id} / #{nested_groups.count}"
  #   puts "\t"*scope + "Extracting childs:"
  #   category = Category.where(one_ass_id: group_id).first_or_initialize
  #   category.title = group_name
  #   category.parent = parent if parent
  #   category.published = true if category.new_record?
  #   pr = Project.first
  #   category.projects << pr unless category.projects.include? pr
  #   category.save
  #   puts category.inspect
  #   group.xpath('Группы/Группа').each do |child_group|
  #     Product.extract_group(child_group.to_xml, scope + 1, category)
  #   end
  # end


  ################################################
  # СВОЙСТВА И ЗНАЧЕНИЯ {{{
  #
  def process_properties_and_values!
    puts STR
    puts 'process_properties_and_values! (НАЧАЛО)'
    puts STR
    doc = Nokogiri::XML(xml)
    doc.xpath("//Классификатор/Свойства/Свойство").each do |property|
      extract_property_and_values(property.to_xml)
    end
    store_extracted_properties_and_values!
    puts STR
    puts 'process_properties_and_values! (КОНЕЦ)'
    puts STR
  end

  def extract_property_and_values(property_xml_string)
    property_xml = Nokogiri::XML(property_xml_string).xpath('Свойство')

    # Получаем данные свойства
    properties_and_values_hash = {
                                  one_ass_id: property_xml.xpath("Ид").text,
                                  title: property_xml.xpath("Наименование").text,
                                }

    # Получаем значения для свойства
    properties_and_values_hash[:values] = []
    property_xml.xpath('ВариантыЗначений/Справочник').each do |child|
      properties_and_values_hash[:values] << {
                                              one_ass_id: child.xpath("ИдЗначения").text,
                                              value: child.xpath("Значение").text,
                                            }
    end

    @properties_and_values_array << properties_and_values_hash

  end

  def store_extracted_properties_and_values!

    @properties_and_values_array.each do |property_attrs|
      # Сохраняем свойства:
      # p "property1c_id: #{property_attrs[:one_ass_id]}"
      charachteristic_name = CharacteristicName.where(one_ass_id: property_attrs[:one_ass_id]).first_or_initialize
      charachteristic_name.title = property_attrs[:title]
      if charachteristic_name.save
        # p "Характеристика '#{charachteristic_name.title}' - создано."
        # Сохраняем значения для свойства:
        property_attrs[:values].each do |value_attrs|
          characteristic_value = charachteristic_name.characteristic_values.where(one_ass_id: value_attrs[:one_ass_id]).first_or_initialize
          characteristic_value.value = value_attrs[:value]
          if characteristic_value.save
            # p "Значение '#{characteristic_value.value}' для характеристки '#{charachteristic_name.title}' - создано."
          else
            # p "Значение '#{value_attrs[:value]}' для характеристки '#{charachteristic_name.title}' - НЕ СОЗДАНО."
            # p "#{characteristic_value.errors.inspect}"
          end
        end
      else
        # p "Характеристика #{property_attrs[:title]} - НЕ СОЗДАНО."
        # p "#{charachteristic_name.errors.inspect}"
      end
    end
  end

  #
  # }}} СВОЙСТВА И ЗНАЧЕНИЯ
  ################################################

  ################################################
  # ТОВАРЫ {{{
  #
  def process_products!
    puts STR
    puts 'process_products! (НАЧАЛО)'
    puts STR
    doc = Nokogiri::XML(xml)
    doc.xpath("//Каталог/Товары/Товар").each do |product|
      extract_product(product.to_xml)
    end
    store_extracted_products!
    puts STR
    puts 'process_products! (КОНЕЦ)'
    puts STR
  end

  # извлекаем продукт из xml тега Товар
  def extract_product(product_xml)
    product = Nokogiri::XML(product_xml).xpath('Товар')

    product_hash = {    one_ass_id: product.xpath("Ид").text,
                        title: product.xpath("Наименование").text,
                        category_one_ass_id: product.xpath("Группы/Ид").text,
                        price: 999,
                        article: product.xpath("Артикул").text,
                        description: product.xpath("Описание").text,
                        producer_one_ass_id: product.xpath("Изготовитель/Ид").text,
                        producer_name: product.xpath("Изготовитель/ОфициальноеНаименование").text,
                    }

    product_hash[:images_one_ass_id] = []
    product.xpath("Картинка").each do |img|
      product_hash[:images_one_ass_id] << img.text
    end

    #Заполняем характеристики
    product.xpath("ЗначенияСвойств/ЗначенияСвойства").each do |characteristic|
      if characteristic.xpath("Значение").text.present?
        product_hash[:product_characteristics] = []
        product_hash[:product_characteristics] << {
                                            characteristic_name_one_ass_id: characteristic.xpath("Ид").text,
                                            characteristic_value_one_ass_id: characteristic.xpath("Значение").text
                                          }
      end
    end

    @products_array << product_hash

    product_hash
  end

  # сохраняем все продукты в базу из собранного массива
  def store_extracted_products!
    @products_array.each do |product_attrs|
      product = Product.where(one_ass_id: product_attrs[:one_ass_id]).first_or_create #создаем чтобы был id для ассациаций
      product.title = product_attrs[:title]
      product.article = product_attrs[:article]
      product.description = product_attrs[:description]
      product.article = product_attrs[:article]

      # Присваиваем категории:
      product.category = Category.find_by one_ass_id: product_attrs[:category_one_ass_id]

      # Сохраняем производителя:
      product.producer = store_extracted_producer! product_attrs[:producer_one_ass_id], product_attrs[:producer_name]

      # Сохраняем картинки:
      if product_attrs[:images_one_ass_id]
        product_attrs[:images_one_ass_id].each do |image_one_ass_id|
          image = store_extracted_image!(image_one_ass_id)
          product.images << image if image
        end
      end

      # Сохраняем характеристики:
      if product_attrs[:product_characteristics]
        product_attrs[:product_characteristics].each do |product_characteristic|
          product_characteristic = store_extracted_characteristic!(product,
                                               product_characteristic[:characteristic_name_one_ass_id],
                                               product_characteristic[:characteristic_value_one_ass_id])
          product.product_characteristics << product_characteristic if product_characteristic
        end
      end

      if product.save
        # puts "product #{product.title} saved"
        # p "#{product.inspect}"
      else
        # puts "product not saved: #{product.errors.inspect}"
      end
    end
  end

  def store_extracted_producer!(one_ass_id, name)
    producer = Producer.where(one_ass_id: one_ass_id).first_or_initialize
    producer.title = name
    if producer.save
      # puts "producer #{producer.title} saved"
      producer
    else
      # puts "producer not saved: #{producer.errors.inspect}"
      nil
    end
  end

  def store_extracted_image!(one_ass_path)
    image = Image.where(one_ass_path: one_ass_path).first_or_initialize
    if image.save
      # puts "image #{image.one_ass_path} saved"
      image
    else
      # puts "image not saved: #{image.errors.inspect}"
      nil
    end
  end

  def store_extracted_characteristic!(product, name_one_ass_id, value_one_ass_id)
    characteristic_name = CharacteristicName.find_by(one_ass_id: name_one_ass_id)
    characteristic_value = CharacteristicValue.find_by(one_ass_id: value_one_ass_id)

    if characteristic_name && characteristic_value
      product_characteristic = product.product_characteristics.where(characteristic_name_id: characteristic_name.id).first_or_initialize
      product_characteristic.characteristic_value = characteristic_value

      if product_characteristic.save
        # p "Характеристика #{characteristic_name.title}:#{characteristic_value.try(:value)} закреплена за товаром."
        product_characteristic
      else
        # p "Характеристика #{characteristic_name.title}:#{characteristic_value.try(:value)} НЕ закреплена за товаром: #{product_characteristic.errors.inspect}"
        # p product_characteristic.inspect
        nil
      end
    else
      nil
    end

  end

  #
  # }}} ТОВАРЫ
  ################################################

  ###############################################
  # ПРЕДЛОЖЕНИЯ {{{
  #
  def process_offers!
    puts STR
    puts 'process_offers! (НАЧАЛО)'
    puts STR
    doc = Nokogiri::XML(xml)
    doc.xpath("//ПакетПредложений/Предложения/Предложение").each do |offer|
      extract_offer(offer.to_xml)
    end
    store_extracted_offers!
    puts STR
    puts 'process_offers! (КОНЕЦ)'
    puts STR
  end

  # извлекаем оффер из xml тега Предложение
  def extract_offer(offer_xml)
    # Парсим предложение:
    offer = Nokogiri::XML(offer_xml).xpath('Предложение')

    #Внимание! Данные хуша заполняем внизу V V V

    # Получаем все цены
    offer_prices = []
    offer.xpath('Цены/Цена').each do |price|
      offer_prices << {
        one_ass_price_type_id: price.xpath("ИдТипаЦены").text,
        price: price.xpath("ЦенаЗаЕдиницу").text.to_f,
        currency: price.xpath("Валюта").text,
        unit: price.xpath("Единица").text,
        coefficient: price.xpath("Коэффициент").text.to_i,
      }
    end

    # Получаем все характеристики
    offer_characteristics = []
    offer.xpath('ХарактеристикиТовара/ХарактеристикаТовара').each do |characteristic|
      offer_characteristics << {
        title: characteristic.xpath("Наименование").text,
        value: characteristic.xpath("Значение").text
      }
    end

    # Заполняем все данные для хеша
    # puts "OFFER offer.xpath('Количество').text: #{offer.xpath('Количество').text}"
    offer_hash = { one_ass_id: offer.xpath("Ид").text,
                   quantity: offer.xpath("Количество").text.present? ? offer.xpath("Количество").text.to_i : 0,
                   offer_prices: offer_prices,
                   offer_characteristics: offer_characteristics }
    # puts "offer_hash[:one_ass_id] = #{offer_hash[:one_ass_id]}"
    # puts "offer_hash[:quantity] = #{offer_hash[:quantity]}"
    @offers_array << offer_hash

    offer_hash

  end

  def store_extracted_offers!
    # Найдем все продукты, для которых эти предложения
    product_ids = []
    @offers_array.each do |offer_attrs|
      product_one_ass_id = offer_attrs[:one_ass_id].split('#').first
      # Ищем продукт, для которого это прендожение:
      product = Product.find_by(one_ass_id: product_one_ass_id)
      product ? product_ids << product.id : nil
    end
    # Удалим все предложения, которые ссылаются на наши продукты, чтобы создать новые предложения
    ProductOffer.where(product_id: product_ids).destroy_all

    @offers_array.each do |offer_attrs|

      # Парсим и получем Ид продкта и предложения6
      # puts "offer_attrs[:one_ass_id] = #{offer_attrs[:one_ass_id]}"
      product_one_ass_id = offer_attrs[:one_ass_id].split('#').first

      # Ищем продукт, для которого это прендожение:
      product = Product.find_by(one_ass_id: product_one_ass_id)

      if product

        offer = product.product_offers.new(one_ass_id: offer_attrs[:one_ass_id])

        # # Очистим все предложения от оффера
        # offer.offer_characteristics.delete_all
        # offer.offer_prices.delete_all

        offer.quantity = offer_attrs[:quantity]
        # Добавляем цены к предложению
        if offer_attrs[:offer_prices]
          offer_attrs[:offer_prices].each do |offer_price_params|
            offer_price = store_extracted_offer_price!(offer, offer_price_params)
            offer.offer_prices << offer_price if offer_price
          end
        end
        # Добавляем характеристики к предложению
        if offer_attrs[:offer_characteristics]
          offer_attrs[:offer_characteristics].each do |offer_characteristic_params|
            offer_characteristic = store_extracted_offer_characteristic!(offer, offer_characteristic_params)
            offer.offer_characteristics << offer_characteristic if offer_characteristic
          end
        end

        if offer.save
          # p "Оффер #{offer.id} создан c с количеством: #{offer.quantity} для товара #{offer.product.title}"
          # p offer.inspect
        else
          # p "Оффер #{offer.id} НЕ создан."
          # p offer.errors.inspect
        end

      else
        # p 'Продукт не найден'
      end
    end

  end

  def store_extracted_offer_characteristic! offer, offer_characteristic_params
    characteristic = offer.offer_characteristics.new
    offer_characteristic_params.each do |key, value|
      characteristic[key] = value
    end
    # characteristic.title = offer_characteristic_params[:title]
    # characteristic.value = offer_characteristic_params[:value]
    if characteristic.save
      # p "Оффер Характеристика #{characteristic.title}:#{characteristic.value} создано"
      characteristic
    else
      # p "Оффер Характеристика #{characteristic.title}:#{characteristic.value} НЕ создано"
      nil
    end
  end

  def store_extracted_offer_price! offer, offer_prices_params
    price = offer.offer_prices.new
    offer_prices_params.each do |key, value|
      price[key] = value
    end
    if price.save
      # p "Оффер цена #{price.price} создано"
      price
    else
      # p "Оффер цена #{price.price} НЕ создано"
      nil
    end
  end

  #
  # }}} ПРЕДЛОЖЕНИЯ
  ###############################################

end