class ChangeColumnDescriptionToContent < ActiveRecord::Migration
  def change
    rename_column :advertisements, :description, :content
  end
end
