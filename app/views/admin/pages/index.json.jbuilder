json.array!(@admin_pages) do |admin_page|
  json.extract! admin_page, :id, :title, :seo_title, :seo_keywords, :seo_description, :body, :published
  json.url admin_page_url(admin_page, format: :json)
end
