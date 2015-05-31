class AddAttachmentToAdvertisement < ActiveRecord::Migration
  def up
    add_attachment :advertisements, :photo
  end

  def down
    remove_attachment :advertisements, :photo
  end
end
