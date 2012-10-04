class Location < ActiveRecord::Base
  #attr_accessible :title, :body
  # Validations
  validates :name, :presence => true
  validates :longitude, :presence => true
  validates :latitude, :presence => true
  has_many :posts
  has_many :follows
  has_many :users, :through => :follows
  def to_hash
  {
    :name => self.name,
    :longitude => self.longitude,
    :id => self.id,
    :latitude => self.latitude
  }
  end
end
