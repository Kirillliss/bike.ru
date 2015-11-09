require 'nokogiri'
class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Квитанция Сбербанк",
                    "Наличными",
                    "Пластиковая карта/электронные деньги (уточните наличие товара у менеджера перед оплатой)",
                  ]
  has_many :line_items, dependent: :destroy
  has_one :coupon
  has_one :payment
  belongs_to :user
  validates :user_id, presence: true
  validates :address, presence: true
  validates :pay_type, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  state_machine :state, :initial => :payment_pending do
    event(:pay) { transition payment_pending: :shipping_pending }
    event(:ship) do
      transition shipping_pending: :done
      transition payment_pending: :done, if: lambda { |order|
        order.pay_type == PAYMENT_TYPES[0] || order.pay_type == PAYMENT_TYPES[1]
      }
    end

    event(:cancel) { transition all - [:canceled] => :canceled }
  end

  def state_rus
    case self.state
    when 'new'
      'новый'
    when 'payment_pending'
      'ожидается оплата'
    when 'shipping_pending'
      'ожидается доставка'
    when 'done'
      'выполнен'
    when 'canceled'
      'отменен'
    when nil
      'неопределено'
    end
  end

  before_create do
    order_last = Order.last
    if order_last.nil? || order_last.number < 1900
      self.number = 1900
    else
      self.number = order_last.number + 1
    end
  end

  def add_params_from_cart(cart)
    # Перегоняем все параметры из корзины в заказ
    cart.line_items.each do |item|
      item.cart_id = nil
      # self.item.order_id = id
      line_items << item
    end
    self.coupon = cart.coupon
    self.price_of_shipping = cart.price_of_shipping
    self.kind_of_shipping = cart.kind_of_shipping
    self.city_title = cart.city_title
    self.city_code = cart.city_code
    self.region_title = cart.region_title
    self.region_code = cart.region_code
  end

  def pay_types_for_delivery(kind_of_shipping)
    kind = kind_of_shipping.mb_chars.downcase
    if kind.include? 'курьер'
      [PAYMENT_TYPES[1]]
    elsif kind.include? 'самовывоз'
      [PAYMENT_TYPES[1], PAYMENT_TYPES[2]]
    else
      [PAYMENT_TYPES[0], PAYMENT_TYPES[2]]
    end
  end

  def total_quantity
    line_items.to_a.sum { |item| item.quantity }
  end

  def total_price (with_coupon = false, with_shipment = false)
    result = line_items.to_a.sum { |item| item.total_price }
    if with_coupon
      coupon ? result = result / 100 * (100 - coupon.amount) : nil
    end
    if with_shipment
      result = result + price_of_shipping
    end
    result
  end

  def self.ping_to_chat(order_num, sum)
    token = 'Kv83H02Ev9AC28V4oqkVcm93OrXnNcJP9SAaD6gJ' # room
    room = 968552

    client = HipChat::Client.new(token, :api_version => 'v2')
    puts client[room].send('Alex BOT', "На сайте новый заказ №#{order_num} на сумму #{sum} рублей", :color => 'green')
  end

  def self.to_xml_1c orders
    Nokogiri::XML::Builder.new do |xml|
      xml.Документы do
        orders.each do |order|
          order.to_xml_1c_body xml
        end
      end
    end.to_xml
  end

  def to_xml_1c
    Nokogiri::XML::Builder.new do |xml|
      to_xml_1c_body xml
    end.to_xml
  end

  def to_xml_1c_body xml
    xml.Документ do
      xml.Ид number #36
      xml.Номер number #36
      xml.Дата created_at.strftime('%Y-%m-%d') #'2007-10-30'
      xml.ХозОперация 'Заказ товара'
      xml.Роль 'Продавец'
      xml.Валюта 'руб'
      xml.Курс '1'
      xml.Сумма total_price
      xml.Контрагенты do
        xml.Контрагент do
          xml.Ид '1#admin# admin'
          xml.Наименование 'admin'
          xml.Роль 'Покупатель'
          xml.ПолноеНаименование 'admin'
          xml.Фамилия user.full_name #'Иванов'
          xml.Имя '' #'admin'
          xml.АдресРегистрации do
            xml.Представление 'ггг'
            xml.АдресноеПоле do
              xml.Тип 'Почтовый индекс'
              xml.Значение '1111'
            end
            xml.АдресноеПоле do
              xml.Тип 'Адресс'
              xml.Значение address
            end
          end
          xml.Представители do
            xml.Представитель do
              xml.Контрагент do
                xml.Отношение 'Контактное лицо'
                xml.Ид '' #'b342955a9185c40132d4c1df6b30af2f'
                xml.Наименование 'admin'
              end
            end
          end
        end # Контрагент
      end # Контрагенты
      xml.Время created_at.strftime('%H:%M:%S') #'15:19:27'
      xml.Товары do
        line_items.each do |line_item|
          xml.Товар do
            xml.Ид line_item.product ? line_item.product.one_ass_id : nil #'ORDER_DELIVERY'
            xml.Наименование line_item.product ? line_item.product.title : nil #'Доставка заказа'
            xml.БазоваяЕдиница 'шт'
            xml.ЦенаЗаЕдиницу line_item.price  #'340.00'
            xml.Количество line_item.quantity
            xml.Сумма line_item.total_price #'340.00'
            xml.ЗначенияРеквизитов do
              xml.ЗначениеРеквизита do
                xml.Наименование 'ВидНоменклатуры'
                xml.Значение 'Услуга'
              end
              xml.ЗначениеРеквизита do
                xml.Наименование 'ТипНоменклатуры'
                xml.Значение 'Услуга'
              end
            end
          end # Товар
        end
      end # Товары
      xml.ЗначенияРеквизитов do
        xml.ЗначениеРеквизита do
          xml.Наименование 'Метод оплаты'
          xml.Значение 'Наличный расчет'
        end
      end # ЗначенияРеквизитов
    end # Документ
  end

end
