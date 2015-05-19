class AddSharedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :shared, :integer, default: 0
  end
end
