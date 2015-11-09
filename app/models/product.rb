require 'nokogiri'
class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :import
  belongs_to :producer
  belongs_to :stock
  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :main_image, class_name: 'Image'
  has_many :line_items, dependent: :destroy
  belongs_to :characteristics_group
  has_many :through_product_characteristics
  has_many :characteristic_names, through: :through_product_characteristics
  has_many :product_characteristics
  has_many :product_offers, dependent: :destroy
  has_many :offer_prices, through: :product_offers
  belongs_to :discount

  scope :aviable, -> { published }
  scope :quantityable, ->{ joins(:product_offers).where("product_offers.quantity > 0").uniq }

  scope :published, -> { quantityable }

  scope :benefits, -> { where benefit: true } # Выгодные предложения
  scope :hits, -> { where hit: true }  # Хиты
  scope :markdowns, -> { where markdown: true } # Товары с уценкой
  scope :frontpageable, -> { aviable.where(frontpageable: true) }
  # Фильтры поиска:
  scope :filter_price, ->(price_from, price_to) { where "price >= ? and price <= ?", price_from, price_to }
  scope :filter_producer, ->(producer_id) { where producer_id: producer_id }
  scope :filter_title, ->(title) { where "title ilike :title or description ilike :title", title: "%#{title}%" }

  scope :min_price, -> { order(:price).first }
  scope :max_price, -> { order(:price).last }

  before_destroy :ensure_not_referenced_by_any_line_item
  validates :title, presence: true
  #validates :price, presence: true
  # validates :article, presence: true
  #validates :category, associated: true

  accepts_nested_attributes_for :images, :reject_if => :all_blank, :allow_destroy => true

  delegate :project_names, to: :category

  COLUMNS_FOR_IMPORT = %w(title article producer_price)

  def self.imaged(limit = 6)
    ids = Image.where.not(image: nil, imageable_id: nil).where(imageable_type: 'Product').select(:imageable_id).order('RANDOM()').limit(6)
    Product.where(id: ids)
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  # def self.create_or_nothing(product_params = {}, producer_id)
  #   producer = Producer.find(producer_id)

  #   if !producer.products.where(article: product_params[:article]).first
  #     product = producer.products.new(product_params)
  #     if product.save!
  #       p "Создано!"
  #     else
  #       p "Не создано!"
  #     end
  #   end
  # end

  def self.extract_property_and_values(property_xml_string)
    property_xml = Nokogiri::XML(property_xml_string).xpath('/Свойство')
    property1c_id = property_xml.xpath("Ид").text
    p "property1c_id: #{property1c_id}"
    charachteristic_name = CharacteristicName.where(one_ass_id: property1c_id).first_or_initialize
    charachteristic_name.title = property_xml.xpath("Наименование").text
    p "Обрабатываем характеристику '#{charachteristic_name.title}'."

    if charachteristic_name.save
      p "Характеристика '#{charachteristic_name.title}' - создано."
    else
      p "Характеристика '#{charachteristic_name.title}' - НЕ СОЗДАНО."
      p "#{charachteristic_name.errors.inspect}"
    end

    # идем на цикл значений для характеристики
    property_xml.xpath('ВариантыЗначений/Справочник').each do |child|
      value1c_id = child.xpath("ИдЗначения").text
      characteristic_value = charachteristic_name.characteristic_values.where(one_ass_id: value1c_id).first_or_initialize
      characteristic_value.value = child.xpath("Значение").text
      p "Обрабатываем значение '#{characteristic_value.value}' для характеристки '#{charachteristic_name.title}'."
      if characteristic_value.save
        p "Значение '#{characteristic_value.value}' для характеристки '#{charachteristic_name.title}' - создано."
      else
        p "Значение '#{characteristic_value.value}' для характеристки '#{charachteristic_name.title}' - НЕ СОЗДАНО."
        p "#{characteristic_value.errors.inspect}"
      end
    end

  end

  # def self.extract_product(product_xml_string)
  #   product_xml = Nokogiri::XML(product_xml_string).xpath('/Товар')
  #   prod_id = product_xml.xpath("Ид").text
  #   puts "product_xml.xpath(Ид).text = #{prod_id}"
  #   product = Product.where(one_ass_id: product_xml.xpath("Ид").text).first_or_initialize
  #   product.title = product_xml.xpath("Наименование").text
  #   product.category = Category.find_by(one_ass_id: product_xml.xpath("Группы/Ид").text)
  #   product.price = 999
  #   product.article = product_xml.xpath("Артикул").text
  #   product.description = product_xml.xpath("Описание").text
  #   product.published = true

  #   pas = product_xml.xpath("Изготовитель/Ид").text
  #   p_title = product_xml.xpath("Изготовитель/ОфициальноеНаименование").text
  #   producer = Producer.where(one_ass_id: pas).first_or_initialize
  #   producer.title = p_title
  #   if producer.save
  #     puts "producer #{producer.title} saved"
  #   else
  #     puts "producer not saved: #{producer.errors.inspect}"
  #   end

  #   product.producer = producer
  #   if product.save
  #     puts "product #{product.title} saved"
  #   else
  #     puts "product not saved: #{product.errors.inspect}"
  #   end

  #   product_xml.xpath("Картинка").each do |img|
  #     image = Image.where(one_ass_path: img.text).first_or_initialize
  #     product.images << image unless product.images.include? image
  #     if image.save
  #       puts "image #{image.one_ass_path} saved"
  #     else
  #       puts "image not saved: #{image.errors.inspect}"
  #     end
  #   end

  #   #Заполняем характеристики
  #   product_xml.xpath("ЗначенияСвойств/ЗначенияСвойства").each do |characteristic|
  #     if characteristic.xpath("Значение").text.present?
  #       characteristic_name = CharacteristicName.find_by(one_ass_id: characteristic.xpath("Ид").text)
  #       characteristic_value = CharacteristicValue.find_by(one_ass_id: characteristic.xpath("Значение").text)

  #       product_characteristic = product.product_characteristics.where(characteristic_name_id: characteristic_name.id).first_or_initialize
  #       product_characteristic.characteristic_value = characteristic_value

  #       if product_characteristic.save
  #         p "Характеристика #{characteristic_name.title}:#{characteristic_value.try(:value)} закреплена за товаром."
  #       else
  #         p "Характеристика #{characteristic_name.title}:#{characteristic_value.try(:value)} НЕ закреплена за товаром: #{product_characteristic.errors.inspect}"
  #       end
  #     else
  #       p "Для ид '#{characteristic.xpath("Ид").text}' не получено значение"
  #     end

  #   end

  #   product

  # end

  def self.extract_offer(offer_xml_string)
    # offer_xml = Nokogiri::XML(offer_xml_string).xpath('/Предложение')
    # one_ass_id_full = offer_xml.xpath("Ид").text
    # product_one_ass_id = one_ass_id_full.split('#').first
    # product_offer_one_ass_id = one_ass_id_full.split('#').second
    # puts "product_one_ass_id: #{product_one_ass_id}"
    # puts "offer_xml: #{offer_xml}"
    price_xml = offer_xml.xpath("Цены/Цена").first
    if price_xml
      price = price_xml.xpath("ЦенаЗаЕдиницу").text
      unit = price_xml.xpath("Единица").text
    end
    puts "New price for product_one_ass_id #{product_one_ass_id} it: #{price} за #{unit}"
    product = Product.find_by(one_ass_id: product_one_ass_id)

    if product
      puts product.inspect
      puts "New price for #{product.title} it: #{price} за #{unit}"
      product.price = price
      product.unit = unit
      product.published = true
      if product.save
        puts "Prices updated: #{product.price} #{product.unit}"
      else
        puts "error saving product:"
        puts product.errors.inspect
      end
    else
      puts "No product"
    end

    # Сохранение предложения:
    offer = nil
    if product
      offer = product.product_offers.where(one_ass_id: product_offer_one_ass_id).first_or_initialize

      # Очистим все предложения от оффера
      offer.offer_characteristics.delete_all
      offer.offer_prices.delete_all

      # Добавим все предложения от оффера
      offer_xml.xpath("ХарактеристикиТовара/ХарактеристикаТовара").each do |characteristic_xml|
        characteristic = offer.offer_characteristics.new
        characteristic.title = characteristic_xml.xpath("Наименование").text
        characteristic.value = characteristic_xml.xpath("Значение").text
        if characteristic.save
          p "Оффер Характеристика #{characteristic.title}:#{characteristic.value} создано"
        else
          p "Оффер Характеристика #{characteristic.title}:#{characteristic.value} НЕ создано"
        end
      end

      offer_xml.xpath("Цены/Цена").each do |price_xml|
        price = offer.offer_prices.new
        price.one_ass_price_type_id = price_xml.xpath("ИдТипаЦены").text
        price.price = price_xml.xpath("ЦенаЗаЕдиницу").text
        price.currency = price_xml.xpath("Валюта").text
        price.unit = price_xml.xpath("Единица").text
        price.coefficient = price_xml.xpath("Коэффициент").text
        if price.save
          p "Оффер цена #{price.price} создано"
        else
          p "Оффер цена #{price.price} НЕ создано"
        end
      end

      quantity = offer_xml.xpath("Количество").text
      p "Количество: #{quantity}"
      if quantity.present?
        offer.quantity = quantity
        p "Количество теперь равно #{quantity}."
      else
        offer.quantity = 0
        p "Количество обнулилось."
      end

      if offer.save
        p "Оффер #{offer.id} создан."
      else
        p "Оффер #{offer.id} НЕ создан. #{offer.errors.inspect}"
      end

    end

    return product, offer
  end

  def image_url(size = :product)
    if images.any? && images.first.image.present?
      images.first.image_url(size)
    else
      'http://placehold.it/330x230'
    end
  end

  def offer_price_min
    # prices = []
    # product_offers.each do |offer|
    #   offer.offer_prices.each do |price|
    #     prices << price.price
    #   end
    # end
    # prices.min
    offer_prices.order(:price).first
  end

  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end

end