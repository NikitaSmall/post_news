class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.belongs_to :author, index: true
      t.boolean :main
      t.boolean :featured

      t.timestamps
    end
  end
end
