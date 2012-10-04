class AppQuery

  ################################
  #  DO NOT MODIFY THIS SECTION  #
  ################################

  attr_accessor :posts
  attr_accessor :users
  attr_accessor :user
  attr_accessor :locations
  attr_accessor :following_locations
  attr_accessor :location

  ###########################################
  #  TODO: Implement the following methods  #
  ###########################################

  # Purpose: Show all the locations being followed by the current user
  # Input:
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @following_locations - An array of hashes of location information.
  #                          Order does not matter.
  #                          Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  # Output: None
  def get_following_locations(user_id)
    @following_locations = []
    followings = User.find(user_id).follows
    followings.each do |following|
      @following_locations << following.location.to_hash
    end
  end

  # Purpose: Show the information and all posts for a given location
  # Input:
  #   location_id - The id of the location for which to show the information and posts
  # Assign: assign the following variables
  #   @location - A hash of the given location. The hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #   @posts - An array of hashes of post information, for the given location.
  #            Reverse chronological order by creation time (newest post first).
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_posts_for_location(location_id)
    @posts = []
    location=Location.find(location_id)
    @location = location.to_hash
#raise "dude this is the location hash #{@location}"
    posts=location.posts
    posts.each do |post|
      post_hash=post.to_hash
      post_hash[:author_id]=post.user['id']
      post_hash[:author]=post.user['name']
      post_hash[:created_at]=post.created_at
      post_hash[:text]=post.msg
      post_hash[:location]=location.to_hash
      @posts << post_hash
    end
    @posts.sort_by! do |post|
      post[:created_at]
    end.reverse!
  end

  # Purpose: Show the current user's stream of posts from all the locations the user follows
  # Input:
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @posts - An array of hashes of post information from all locations the current user follows.
  #            Reverse chronological order by creation time (newest post first).
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_stream_for_user(user_id)
  
    @posts = []
    followings = User.find(user_id).follows
    followings.each do |following|
      cur_loc = following.location
      cur_loc.posts.each do |posting|
        posting_hash = posting.to_hash
        posting_hash[:author] = posting.user.name
        posting_hash[:created_at]=posting.created_at
        posting_hash[:location]=cur_loc.to_hash
        @posts << posting_hash
      end
    end
    @posts.sort_by! do |post_hsh|
      post_hsh[:created_at]
    end.reverse!
  end

  # Purpose: Retrieve the locations within a GPS bounding box
  # Input:
  #   nelat - latitude of the north-east corner of the bounding box
  #   nelng - longitude of the north-east corner of the bounding box
  #   swlat - latitude of the south-west corner of the bounding box
  #   swlng - longitude of the south-west corner of the bounding box
  #   user_id - the user id of the current user
  # Assign: assign the following variables
  #   @locations - An array of hashes of location information, which lie within the bounding box specified by the input.
  #                In increasing latitude order.
  #                At most 50 locations.
  #                Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #     * :follows - true if the current user follows this location. false otherwise.
  # Output: None
  def get_nearby_locations(nelat, nelng, swlat, swlng, user_id)
    places = Location.where(:latitude => swlat..nelat, :longitude => swlng..nelng)
    @locations = []
    places.each do |loc|
      loc_hash = loc.to_hash
      loc_hash[:follows] = User.find(user_id).locations.include? loc
      @locations << loc_hash
    end
    @locations.sort_by! do |loc|
      loc[:latitude]
    end
    @locations = @locations[0..49]
  end

  # Purpose: Create a new location
  # Input:
  #   location_hash - A hash of the new location information.
  #                   The hash MAY include:
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: None
  # Output: true if the creation is successful, false otherwise
  def create_location(location_hash={})
    @location=Location.new(location_hash)
    @location.save()
  end

  # Purpose: The current user follows a location
  # Input:
  #   user_id - the user id of the current user
  #   location_id - The id of the location the current user should follow
  # Assign: None
  # Output: None
  # NOTE: Although the UI will never call this method multiple times,
  #       we may call it multiple times to test your schema/models.
  #       Your schema/models/code should prevent corruption of the database.
  def follow_location(user_id, location_id)
    Follow.create(:user_id=>user_id, :location_id=>location_id) and return
  end

  # Purpose: The current user unfollows a location
  # Input:
  #   user_id - the user id of the current user
  #   location_id - The id of the location the current user should unfollow
  # Assign: None
  # Output: None
  # NOTE: Although the UI will never call this method multiple times,
  #       we may call it multiple times to test your schema/models.
  #       Your schema/models/code should prevent corruption of the database.
  def unfollow_location(user_id, location_id)
    Follow.delete_all ["user_id=? AND location_id=?",user_id,location_id] and return
  end

  # Purpose: The current user creates a post to a given location
  # Input:
  #   user_id - the user id of the current user
  #   post_hash - A hash of the new post information.
  #               The hash may include:
  #     * :location_id - the id of the location
  #     * :text - the text of the posts
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: None
  # Output: true if the creation is successful, false otherwise
  def create_post(user_id, post_hash={})
#raise "location id is nil #{post_hash[:location_id] == nil}"
    new_post = Post.new(:user_id=>user_id, :location_id=>post_hash[:location_id],:msg=>post_hash[:text])
    new_post.save
  end

  # Purpose: Create a new user
  # Input:
  #   user_hash - A hash of the new post information.
  #               The hash may include:
  #     * :name - name of the new user
  #     * :email - email of the new user
  #     * :password - password of the new user
  #     NOTE: Although the UI will always populate all these fields in this hash,
  #           we may use hashes with missing fields to test your schema/models.
  #           Your schema/models/code should prevent corruption of the database.
  # Assign: assign the following variables
  #   @user - the new user object
  # Output: true if the creation is successful, false otherwise
  # NOTE: This method is already implemented, but you are allowed to modify it if needed.
  def create_user(user_hash={})
    @user = User.new(user_hash)
    @user.save
  end

  # Purpose: Get all the posts
  # Input: None
  # Assign: assign the following variables
  #   @posts - An array of hashes of post information.
  #            Order does not matter.
  #            Each hash should include:
  #     * :author_id - the id of the user who created this post
  #     * :author - the name of the user who created this post
  #     * :text - the contents of the post
  #     * :created_at - the time the post was created
  #     * :location - a hash of this post's location information. The hash should include:
  #         * :id - the location id
  #         * :name - the name of the location
  #         * :latitude - the latitude
  #         * :longitude - the longitude
  # Output: None
  def get_all_posts
    postings = Post.all
    @posts = []
    postings.each do |posting|
      posting_hash = posting.to_hash
      author_name = posting.user.name
      loc_hash = posting.location.to_hash
      posting_hash[:author]=author_name
      posting_hash[:created_at]=posting.created_at
      posting_hash[:location]=loc_hash
      @posts << posting_hash
    end
    return
  end

  # Purpose: Get all the users
  # Input: None
  # Assign: assign the following variables
  #   @users - An array of hashes of user information.
  #            Order does not matter.
  #            Each hash should include:
  #     * :id - id of the user
  #     * :name - name of the user
  #     * :email - email of th user
  # Output: None
  def get_all_users
    @users = []
    people = User.all
    people.each do |person|
      @users << person.to_hash
    end
    return
  end

  # Purpose: Get all the locations
  # Input: None
  # Assign: assign the following variables
  #   @locations - An array of hashes of location information.
  #                Order does not matter.
  #                Each hash should include:
  #     * :id - the location id
  #     * :name - the name of the location
  #     * :latitude - the latitude
  #     * :longitude - the longitude
  # Output: None
  def get_all_locations
    places = Location.all
    @locations = []
    places.each do |place|
      @locations << place.to_hash
    end
    return
  end

  # Retrieve the top 5 users who created the most posts.
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the user
  #   * num_posts - number of posts the user has created
  def top_users_posts_sql
    #"SELECT '' AS name, 0 AS num_posts FROM users WHERE 1=2"
    "SELECT u.name AS name, COUNT(*) as num_posts from users  u JOIN posts p ON u.id=p.user_id GROUP BY u.id ORDER BY num_posts DESC LIMIT 5"
  end

  # Retrieve the top 5 locations with the most unique posters. Only retrieve locations with at least 2 unique posters.
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the location
  #   * num_users - number of unique users who have posted to the location
  def top_locations_unique_users_sql
    #"SELECT '' AS name, 0 AS num_users FROM users WHERE 1=2"
    "SELECT l.name AS name, COUNT(DISTINCT u.id) as num_users  FROM locations l JOIN posts p ON p.location_id = l.id JOIN users u on p.user_id=u.id  GROUP BY l.id HAVING num_users >= 2 ORDER BY num_users DESC LIMIT 5"
  end

  # Retrieve the top 5 users who follow the most locations, where each location has at least 2 posts
  # Retrieve at most 5 rows.
  # Returns a string of the SQL query.
  # The resulting columns names must include (but are not limited to):
  #   * name - name of the user
  #   * num_locations - number of locations (has at least 2 posts) the user follows
  def top_users_locations_sql
    "SELECT u.name AS name, COUNT(DISTINCT l.id) AS num_locations FROM users u JOIN follows f ON f.user_id = u.id JOIN locations l ON l.id = f.location_id AND l.id IN (SELECT l.id AS loc_num FROM locations l JOIN posts p ON l.id = p.location_id GROUP BY l.id HAVING COUNT(DISTINCT p.id) >= 2) GROUP BY u.id ORDER BY num_locations DESC LIMIT 5"
  end

end
