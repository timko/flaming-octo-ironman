class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.timestamps
    end
  end
end
