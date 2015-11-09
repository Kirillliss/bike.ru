class Person < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  validates :avatar, :first_name, :last_name, :phone, :job_title, :email, :position, presence: true

  scope :aviable, -> { where(published: true).order('position DESC') }

  def full_name
    "#{first_name} #{last_name}"
  end

end
