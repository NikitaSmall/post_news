class RenameColumnInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :author_id, :user_id
  end
end
