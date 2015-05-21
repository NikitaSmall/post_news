class AddLinkToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :link, :string
  end
end
