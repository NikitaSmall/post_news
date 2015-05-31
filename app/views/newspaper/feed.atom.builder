atom_feed(language: 'ru-RU') do |feed|
  feed.title 'Свежие новости от Apex-news'
  feed.updated @posts.first.try(:created_at)

  feed.link root_url

  @posts.each do |post|
    feed.entry(post, url: read_post_url(post)) do |entry|
      entry.title post.title
      entry.description truncate strip_tags(post.content.html_safe), length: 180

      entry.published Russian::strftime(post.created_at, "%d %B %Y, %A, %H:%M")
      entry.updated Russian::strftime(post.updated_at, "%d %B %Y, %A, %H:%M")
      entry.author post.user.username

      entry.link read_post_url(post)
      entry.guide read_post_url(post)
    end
  end
end