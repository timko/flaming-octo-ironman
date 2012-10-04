class RemovePostedOnFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :posted_on
  end

  def down
    add_column :posts, :posted_on, :timestamp
  end
end
