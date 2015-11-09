class Category < ActiveRecord::Base
  has_many :category_projects
  has_many :projects, through: :category_projects
  has_many :products
  has_many :producers, through: :products
  has_many :product_offers, through: :products
  belongs_to :discount

  before_destroy :unset_products

  validates :title, presence: true
  has_ancestry

  scope :published, -> {where(published: true).order(:position).uniq}
  scope :public_roots, -> {roots.published}
  scope :toppers, -> {where(topper: true).published.limit(3)}
  scope :quantityable, ->{ joins(:product_offers).where("product_offers.quantity > 0")}

  def best_seller_product
    child_products.find_by(special_offer: true)
  end

  def self.roots_with_chidlren
    rwc = []
    roots.order(:position).each do |root_cat|
      rwc << root_cat unless root_cat.childess?
    end
    rwc
  end

  def open?(params_id)
    path_ids.include?(params_id.to_i) || subtree_ids.include?(params_id.to_i)
  end

  def childess?
    child_products.published.count == 0
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def child_products
    Product.where(id: child_product_ids)
  end

  def child_product_ids
    Product.where(category_id: child_category_ids_with_self).pluck(:id).uniq
  end

  def child_category_ids_with_self
    if descendant_ids.any?
      [descendant_ids, id]
    else
      id
    end
  end

  def project_names
    if root?
      projects.pluck(:title).join(", ")
    else
      if parent.root?
        parent.projects.pluck(:title).join(", ")
      else
        parent.parent.projects.pluck(:title).join(", ")
      end
    end
  end

  def ordered_children
    # children.order(:position)
    descendants.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }#.unshift(["-- none --", nil])
  end

  def draft?
    !published
  end

  def image_url(size = :product)
    result_image_url = 'http://placehold.it/300x200'
    image = Image.where.not(image: nil).where.not(image: '').where(imageable_id: child_product_ids, imageable_type: 'Product').limit(1).first
    if image && image.image.present?
      result_image_url = image.image_url(size)
    end
    result_image_url
  end

  private
    def unset_products
      products.update_all(category_id: Category.first)
    end
end
