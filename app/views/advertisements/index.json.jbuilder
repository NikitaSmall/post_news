json.array!(@advertisements) do |advertisement|
  json.extract! advertisement, :id, :title, :content, :enabled
  json.url advertisement_url(advertisement, format: :json)
end
