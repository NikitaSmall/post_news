json.array!(@advertisements) do |advertisement|
  json.extract! advertisement, :id, :title, :description, :enabled
  json.url advertisement_url(advertisement, format: :json)
end
