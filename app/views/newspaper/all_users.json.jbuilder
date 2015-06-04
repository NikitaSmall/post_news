json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :rank, :avatar, :created_at, :updated_at
end
