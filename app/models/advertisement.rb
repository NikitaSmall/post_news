class Advertisement < ActiveRecord::Base
  has_attached_file :photo, {
                              :styles => {:thumb => '50x50#', :original => '800x800>'}
                          }.merge(PAPERCLIP_STORAGE_ADV_OPTIONS)
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  validates :title, :description, :photo, :link, presence: true

  def enabled!
    self.enabled = true
    save
  end

  def disabled!
    self.enabled = false
    save
  end
end
