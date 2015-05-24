class AddVisitsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :visits, :integer, default: 0
  end
end
