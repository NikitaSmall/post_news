class AddAttachmentToPosts < ActiveRecord::Migration
  def up
    add_attachment :posts, :photo
  end

  def down
    remove_attachment :posts, :photo
  end
end
