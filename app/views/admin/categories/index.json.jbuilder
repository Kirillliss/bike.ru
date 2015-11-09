json.array!(@players) do |player|
  json.extract! player, :id, :first_name, :middle_name, :last_name
  json.url player_url(player, format: :json)
end
