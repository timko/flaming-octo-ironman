class Post < ActiveRecord::Base
  attr_accessible :msg, :posted_on, :user_id, :location_id
  belongs_to :user
  belongs_to :location
  validates :user_id, :presence => true
  validates :location_id, :presence => true
  validates :msg, :presence => true
  def to_hash
    {
      :text => self.msg,
      :author_id => self.user_id,
      :location_id => self.location_id
    }
  end
end
