json.array!(@posts) do |post|
  json.extract! post, :id, :title, :photo, :content, :user_id, :main, :featured, :position, :created_at, :updated_at
  json.url post_url(post, format: :json)
end
