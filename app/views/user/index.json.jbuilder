json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :rank, :created_at, :updated_at
  json.url post_url(user, format: :json)
end
