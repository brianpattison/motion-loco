describe "Loco::Model" do
  
  it "should be defined" do
    Loco::Model.ancestors.member?(Loco::Observable).should.equal true
  end
  
  # it "should allow for defining a belongs_to relationship" do
  #   should.not.raise(NoMethodError, TypeError) do
  #     class Guest < Loco::Model
  #       adapter 'Loco::FixtureAdapter'
  #       belongs_to :episode
  #       property :first_name
  #       property :last_name
  #     end
  #   end
  # end
  # 
  # it "should accept a record for the belongs_to property" do
  #   @episode = Episode.new
  #   @guest = Guest.new
  #   should.not.raise(NoMethodError, TypeError) do
  #     @guest.episode = @episode
  #   end
  # end
  # 
  # it "show accept a record_id for the belongs_to's id property and load the record when called" do
  #   @guest = Guest.new
  #   @guest.episode_id = 1
  #   @guest.episode.title.should.equal "Watch my show!"
  # end
  # 
  # it "should raise a type error if the wrong model type is passed on the belongs_to property" do
  #   should.raise(TypeError) do
  #     @guest = Guest.new
  #     @guest.episode = "Hello"
  #   end
  # end
  # 
  # it "should allow for defining a has_many relationship" do
  #   should.not.raise(NoMethodError, TypeError) do
  #     class Episode
  #       has_many :guests
  #     end
  #   end
  # end
  # 
  # it "should accept an empty array for the has_many property" do
  #   @episode = Episode.new
  #   should.not.raise(NoMethodError, TypeError) do
  #     @episode.guests = []
  #   end
  # end
  # 
  # it "should accept an array with the proper record type for the has_many property" do
  #   @episode = Episode.new
  #   @guests = [Guest.new(first_name: 'Joe', last_name: 'Blow')]
  #   should.not.raise(NoMethodError, TypeError) do
  #     @episode.guests = @guests
  #   end
  #   @episode.guests.first.first_name.should.equal 'Joe'
  # end
  # 
  # it "should raise a type error if the wrong model type is passed on the has_many property" do
  #   @episode = Episode.new
  #   @guests = [Show.new]
  #   should.raise(TypeError) do
  #     @episode.guests = @guests
  #   end
  # end
  # 
  # it "should load the has_many objects if the ids exist" do
  #   @show = Show.find(1)
  #   @show.episodes.length.should.equal 2
  #   @show.episodes.first.title.should.equal "Watch my show!"
  # end
  
end