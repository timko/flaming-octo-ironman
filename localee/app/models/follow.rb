class Follow < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :location
  validates_uniqueness_of :user_id, :scope => :location_id
  validates :user_id, :presence => true
  validates :location_id, :presence => true
end
