class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :strinh
  end
end
