class Payment < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :order_id
  validates_presence_of :price

  def init_settings
    {
      sMerchantLogin: Rails.application.secrets.merchant_login,
      sMerchantPass1: Rails.application.secrets.merchant_pass_1,
      sMerchantPass2: Rails.application.secrets.merchant_pass_2
    }
  end

  def verify_params(price, signature)
    return false unless price == self.price
    s_signature_value = price.to_s + ':' + self.id.to_s + ':' + init_settings[:sMerchantPass2]
    md5 = Digest::MD5.new
    digest = md5.hexdigest(s_signature_value.encode('windows-1251'))
    digest.upcase!
    digest == signature
  end

  def paid_params
    s_signature_value = init_settings[:sMerchantLogin] + ':' +
      self.price.to_s + ':' +
      self.id.to_s + ':' +
      init_settings[:sMerchantPass1]
 
    md5 = Digest::MD5.new
    digest = md5.hexdigest(s_signature_value.encode('windows-1251'))
    Rack::Utils.build_query({
      'MrchLogin' => init_settings[:sMerchantLogin],
      'OutSum' => self.price.to_s,
      'InvId' => self.id.to_s,
      'SignatureValue'  => digest,
      'Culture' => 'ru'
    })
  end

  def remote_url
    if Rails.env.production?
      'https://auth.robokassa.ru/Merchant/Index.aspx?' +
      self.paid_params
    else
      self.test_remote_url
    end
  end

  def test_remote_url
    'http://test.robokassa.ru/Index.aspx?' +
    self.paid_params
  end

  state_machine :state, :initial => :waiting do

    after_transition any => :paid do
    end

    event :pay do
      transition [:waiting] => :paid
    end

    event :cancel do
      transition [:waiting] => :canceled
    end
  end

end
