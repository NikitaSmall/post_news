class Post < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user

  scope :none, -> { where('1 = 0') }
  scope :main, -> { where(main: true) }
  scope :hidden, -> { where(main: false) }
  scope :featured, -> { where(featured: true) }
  scope :by_position, -> { order(position: :desc) }
  scope :by_position_asc, -> { order(position: :asc) }
  scope :user_posts, ->(user) { where(user: user) }

  has_attached_file :photo, {
                              styles: { thumb: '50x50#', original: '800x800>' }
                            }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :title, :content, :photo, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  after_create :check_featured, :set_position

  def next
    Post.where('position > ?', position).order(position: :asc).first
  end

  def prev
    Post.where('position < ?', position).order(position: :asc).last
  end

  def next_main
    Post.main.where('position > ?', position).order(position: :asc).first
  end

  def prev_main
    Post.main.where('position < ?', position).order(position: :asc).last
  end

  def switch(post)
    self.position, post.position = post.position, position
    post.save
    save
  end

  def main!
    self.main = true
    save
  end

  def hide!
    self.main = false
    defeature!
    save
  end

  def featured!
    self.featured = true if main
    save
  end

  def featured?
    featured
  end

  def defeature!
    self.featured = false
    save
  end

  def shared!
    self.shared += 1
    save
  end

  def visits!
    self.visits += 1
    save
  end

  def self.search(word)
    word = "%#{word}%"
    where 'lower(title) LIKE ? OR lower(content) LIKE ?', word.downcase, word.downcase
  end

  def self.archived_posts(start_date, end_date)
    date_from = start_date.blank? ? 1.year.ago : Date.parse(start_date)
    date_to = end_date.blank? ? Date.today : Date.parse(end_date)

    where(created_at: date_from.beginning_of_day..date_to.end_of_day)
  end

  def self.popular_tags(limit = 20)
    ActsAsTaggableOn::Tag.most_used(limit).where('taggings_count > 0')
  end

  def self.popular_tagged_post(limit = 20)
    tags = popular_tags(limit)
    popular_posts = []

    tags.each do |tag|
      popular_posts << tagged_with(tag.name).to_a
    end
    popular_posts.flatten.first(limit)
  end

  def self.related_tags(tag)
    tag_count = Option.get_value('tag_count').to_i
    posts = Post.tagged_with(tag)
    tags = Hash.new(0)

    posts.each do |post|
      post.tag_list.each do |t|
        tags[t] += 1
      end
    end
    tags = tags.delete_if { |t, count| count < tag_count || t.downcase == tag.downcase }
    tags.keys
  end

  protected

  def check_featured
    defeature! unless main
  end

  def set_position
    self.position ||= id
    save
  end
end
