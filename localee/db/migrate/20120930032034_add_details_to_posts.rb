class AddDetailsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer
    add_column :posts, :location_id, :integer
  end
end
