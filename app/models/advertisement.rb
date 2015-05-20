class Advertisement < ActiveRecord::Base
  has_attached_file :photo, {
                              :styles => {:thumb => '50x50#', :original => '800x800>'}
                          }.merge(PAPERCLIP_STORAGE_ADV_OPTIONS)
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
