class RemoveFriends < ActiveRecord::Migration
  def change
    drop_table :users_users
  end
end
