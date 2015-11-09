class Coupon < ActiveRecord::Base

  belongs_to :user
  belongs_to :cart
  belongs_to :order

  validates :amount, :code, presence: true

  # before_create do
  #   self.code = ('1'..'10').map { ('a'..'z').to_a[rand(26)] }.join.upcase
  # end

  def apply
    used_at = Time.now
    save
  end

end
