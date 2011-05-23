class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table 'users_users', :id => false do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps
    end
  end

  def self.down
    drop_table 'users_users'
  end
end
