class Project < ActiveRecord::Base
  has_many :category_projects, dependent: :destroy
  has_many :categories, ->{uniq}, through: :category_projects

  has_many :page_projects, dependent: :destroy
  has_many :pages, ->{uniq}, through: :page_projects
  
  validates :title, presence: true, uniqueness: true
  validates :hostname, presence: true, uniqueness: true

  def child_ids
    child_ids = []
    category_ids.each do |root_id|
      child_ids << Category.subtree_of(root_id).pluck(:id)
    end
    child_ids
  end

  def products
    Product.where(category_id: child_ids).uniq
  end
end
