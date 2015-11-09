json.array!(@admin_tizers) do |admin_tizer|
  json.extract! admin_tizer, :id, :title, :url
  json.url admin_tizer_url(admin_tizer, format: :json)
end
