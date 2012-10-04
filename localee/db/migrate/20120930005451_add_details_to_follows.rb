class AddDetailsToFollows < ActiveRecord::Migration
  def change
    add_column :follows, :user_id, :integer
    add_column :follows, :location_id, :integer
  end
end
