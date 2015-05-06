class Post < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  scope :main, -> { where(main: true) }
  scope :hidden, -> { where(main: false) }
  scope :by_position, -> { order(position: :desc) }
  scope :by_position_asc, -> { order(position: :asc) }

  has_attached_file :photo, {
                              :styles => {:thumb => '50x50#', :original => '800x800>'}
                          }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  validates :title, :content, :photo, presence: true
  validates :title, uniqueness: true

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
    self.position, post.position = post.position, self.position
    post.save
    self.save
  end

  def main!
    self.main = true
    self.save
  end

  def hide!
    self.main = false
    defeature!
    self.save
  end

  def featured!
    self.featured = true if main
    self.save
  end

  def featured?
    self.featured
  end

  def defeature!
    self.featured = false
    self.save
  end

  def self.search(word)
    word = "%#{word}%"
    where 'lower(title) LIKE ? OR lower(content) LIKE ?', word.downcase, word.downcase
  end

  protected
  def check_featured
    defeature! unless main
  end

  def set_position
    self.position ||= self.id
    self.save
  end
end
