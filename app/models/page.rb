class Page < ActiveRecord::Base
  # has_ancestry
  has_many :page_projects
  has_many :projects, through: :page_projects
  has_ancestry orphan_strategy: :rootify
  validates :title, presence: true
  validates :body, presence: true
  
  scope :published, -> {where published: true}
  scope :aviable, -> {where published: true}
  scope :everywhereable, -> {where everywhereable: true}
  scope :public_roots, -> {roots.published.order(:position)}

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def project_names
    if root?
      projects.pluck(:title).join(", ")
    else
      parent.projects.pluck(:title).join(", ")
    end
  end
end
