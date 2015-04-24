class Post < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  scope :main, -> { where(main: true) }
  scope :hidden, -> { where(main: false) }
  scope :by_position, -> { order(position: :desc) }
  scope :by_position_asc, -> { order(position: :asc) }

  validates :title, :content, presence: true
  validates :title, uniqueness: true

  def next
    Post.where('position > ?', position).order(position: :asc).first
  end

  def prev
    Post.where('position < ?', position).order(position: :asc).last
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
    self.save
  end

  def set_position
    self.position ||= self.id
    self.save
  end
end
