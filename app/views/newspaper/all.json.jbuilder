json.array!(@posts) do |post|
  json.extract! post, :id, :title, :photo, :content, :user_id, :main, :featured, :position, :created_at, :updated_at
  json.url read_post_url(post)
end
