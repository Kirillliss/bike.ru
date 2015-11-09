class PageProject < ActiveRecord::Base
  belongs_to :page
  belongs_to :project
end
