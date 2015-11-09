# spec/support/deppkind/session_helpers.rb
require 'nokogiri'
require 'httparty'

module Xml
  class OneAsser
    include HTTParty
    base_uri 'localhost'

    def post_one_ass(xml, name = 'import')
      options = {
        query: {
          mode: 'file',
          filename: "#{name}.xml"
        },

        :headers => {
          "Content-Type" => "application/xml"
        },

        :body => xml
      }
      self.class.post("/products/import", options)
    end
  end

  module GeneratorHelpers
    
    def post_like_one_ass(xml_body_string, filename = 'import.xml')
        # НЕ ТРОГАТЬ ЭТИ ДВЕ СТРОЧКИ БЛЕАТЬ!
      url_to_post_xml = "products/import?mode=file&filename=#{filename}"
      params_for_xml_posting = { 'CONTENT_TYPE' => 'application/xml', 'ACCEPT' => 'application/xml' }
      # постим типа как 1С
      page.driver.post url_to_post_xml, xml_body_string, params_for_xml_posting

      # puts page.driver.response.body
    end

    def generate_categories_from_array(categories_array)
      # puts categories_array
      Nokogiri::XML::Builder.new do |xml|
        xml.КоммерческаяИнформация do
          xml.Классификатор do
            xml.Группы do
              categories_array.each do |category|
                make_category_xml(xml, category)
              end
            end
          end
        end
      end.to_xml
    end

    def generate_categories_xml(count, with_products = false)

      category_ids = []
      product_ids = []

      Nokogiri::XML::Builder.new do |xml|
        xml.КоммерческаяИнформация do
          xml.Классификатор do
            xml.Группы do
              count.times do
                category_attrs = attributes_for(:category)
                xml.Группа do
                  xml.Ид category_attrs[:one_ass_id]
                  category_ids << category_attrs[:one_ass_id]
                  xml.Наименование category_attrs[:title]
                end
              end
            end
          end
          if with_products
            xml.Каталог do
              xml.Товары do
                category_ids.each do |category_id|
                  count.times do |index|
                    product_attrs = attributes_for(:product)
                    xml.Товар do
                      xml.Ид product_attrs[:one_ass_id]
                      xml.Наименование product_attrs[:title]
                      xml.Группы do
                        xml.Ид category_id
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end.to_xml
    end

    def generate_product_offers_xml(count)
      Nokogiri::XML::Builder.new do |xml|
        xml.КоммерческаяИнформация do
          xml.ПакетПредложений do
            xml.Предложения do
              count.times do |index|
                product = create(:product)
                offer = product.product_offers.first
                offer_characteristic = offer.offer_characteristics.first
                offer_price = offer.offer_prices.first
                xml.Предложение do
                  xml.Ид offer[:one_ass_id]
                  xml.Количество offer[:quantity]
                  xml.ХарактеристикиТовара do
                    xml.ХарактеристикаТовара do
                      xml.Наименование offer_characteristic[:title]
                      xml.Значение offer_characteristic[:value]
                    end
                  end
                  xml.Цены do
                    xml.Цена do
                      xml.ИдТипаЦены offer_price[:one_ass_price_type_id]
                      xml.ЦенаЗаЕдиницу offer_price[:price]
                      xml.Валюта offer_price[:currency]
                      xml.Единица offer_price[:unit]
                      xml.Коэффициент offer_price[:coefficient]
                    end
                  end
                end
              end
            end
          end
        end
      end.to_xml
    end

    def generate_category_xml(one_ass_id, title)
      Nokogiri::XML::Builder.new do |xml|
        make_category_xml(xml, {one_ass_id: one_ass_id, title: title})
      end.to_xml
    end


    def generate_product_xml(product)
      Nokogiri::XML::Builder.new do |xml|
        make_product_xml(xml, product)
      end.to_xml
    end

    def generate_product_offer_xml(offer_params)
      Nokogiri::XML::Builder.new do |xml|
        make_product_offer_xml(xml, offer_params)
      end.to_xml
    end

    def generate_property_and_values_xml(property_params)
      Nokogiri::XML::Builder.new do |xml|
        make_property_xml(xml, property_params)
      end.to_xml
    end

    private
      # создаем xml кусок и возвращаем для достройки xml объект
      def make_category_xml(xml, category)
        xml.Группа do
          xml.Ид category[:one_ass_id]
          xml.Наименование category[:title]
          if category[:children].present?
            xml.Группы do
              category[:children].each do |child|
                make_category_xml(xml, child)
              end
            end
          end
        end
      end

      def make_product_xml(xml, product)
        xml.Товар do
          xml.Ид product[:one_ass_id]
          xml.Наименование product[:title]
          xml.Артикул product[:article]
          xml.Описание product[:description]
          product[:images_one_ass_id].each{|img| xml.Картинка img} if product[:images_one_ass_id]
          xml.Группы do
            xml.Ид product[:category_one_ass_id]
          end
          xml.Изготовитель do
            xml.Ид product[:producer_one_ass_id]
            xml.ОфициальноеНаименование product[:producer_name]
          end
          xml.ЗначенияСвойств do
            if product[:product_characteristics]
              product[:product_characteristics].each do |characteristic|
                xml.ЗначенияСвойства do
                  xml.Ид characteristic[:characteristic_name_one_ass_id]
                  xml.Значение characteristic[:characteristic_value_one_ass_id]
                end
              end
            end
          end
        end
      end

      def make_product_offer_xml(xml, offer)
        xml.Предложение do
          xml.Ид offer[:one_ass_id]
          xml.ХарактеристикиТовара do
            if offer[:offer_characteristics]
              offer[:offer_characteristics].each do |characteristic|
                xml.ХарактеристикаТовара do
                  xml.Наименование characteristic[:title]
                  xml.Значение characteristic[:value]
                end
              end
            end
          end
          xml.Цены do
            if offer[:offer_prices]
              offer[:offer_prices].each do |price|
                xml.Цена do
                  xml.ИдТипаЦены price[:one_ass_price_type_id]
                  xml.ЦенаЗаЕдиницу price[:price]
                  xml.Валюта price[:currency]
                  xml.Единица price[:unit]
                  xml.Коэффициент price[:coefficient]
                end
              end
            end
          end
          xml.Количество offer[:quantity]
        end
      end

      def make_property_xml(xml, property_params)
        xml.Свойство do
          xml.Ид property_params[:one_ass_id]
          xml.Наименование property_params property_params[:title]
          xml.ВариантыЗначений do
            property_params[:title].each do |params|
              xml.Справочник do
                xml.one_ass_id params[:one_ass_id]
                xml.value params[:value]
              end
            end
          end
        end
      end

  end
end