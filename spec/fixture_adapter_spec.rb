describe "Loco::FixtureAdapter" do
  
  it "should be defined" do
    Loco::FixtureAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should load records on #find from the fixtures directory based on class, file name, and id" do
    show = Show.find(1)
    show.id.should.equal 1
    show.title.should.equal "Brian's Podcast"
    
    show = Show.find(2)
    show.id.should.equal 2
    show.title.should.equal "Brian's Video Clip Show"
    
    episode = Episode.find(1)
    episode.id.should.equal 1
    episode.episode_number.should.equal 20
    episode.title.should.equal "Watch my show!"
    
    episode = Episode.find(3)
    episode.id.should.equal 3
    episode.episode_number.should.equal 40
    episode.title.should.equal "Here are some YouTube clips"
  end
  
  it "should accept a block on #find and the loaded record should be returned" do
    show = Show.find(1) do |loaded_show|
      loaded_show.id.should.equal 1
      loaded_show.title.should.equal "Brian's Podcast"
    end
    
    episode = Episode.find(3) do |loaded_episode|
      loaded_episode.id.should.equal 3
      loaded_episode.episode_number.should.equal 40
      loaded_episode.title.should.equal "Here are some YouTube clips"
    end
  end
  
  it "should return an array of all records for a model using #find without an id" do
    shows = Show.find
    shows.length.should.equal 2
    
    episodes = Episode.find
    episodes.length.should.equal 5
  end
  
  it "should return an array of records from multiple ids" do
    shows = Show.find([1, 2])
    shows.length.should.equal 2
    shows.first.title.should.equal "Brian's Podcast"
    shows.last.title.should.equal "Brian's Video Clip Show"
    
    episodes = Episode.find([2, 3, 5])
    episodes.length.should.equal 3
    episodes.first.title.should.equal "I don't really have a show"
    episodes.last.title.should.equal "What? You want more clips!?"
  end
  
  it "should return an array of all records matching parameters given as a Hash" do
    episodes = Episode.find(show_id: 1)
    episodes.length.should.equal 2
    episodes.first.title.should.equal "Watch my show!"
    
    episodes = Episode.find(show_id: 2)
    episodes.length.should.equal 3
    episodes.first.title.should.equal "Here are some YouTube clips"
  end
  
end