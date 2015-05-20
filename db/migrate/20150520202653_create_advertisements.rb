class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :title
      t.string :description
      t.boolean :enabled

      t.timestamps
    end
  end
end
