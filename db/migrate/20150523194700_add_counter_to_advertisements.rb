class AddCounterToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :visits, :integer, default: 0
  end
end
