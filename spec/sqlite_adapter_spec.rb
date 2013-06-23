describe "Loco::SQLiteAdapter" do
  
  it "should be defined" do
    Loco::SQLiteAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  Player.all.each do |player|
    player.destroy
  end
  App::Persistence["loco.players.last_id"] = nil
  
  Score.all.each do |score|
    score.destroy
  end
  App::Persistence["loco.scores.last_id"] = nil
  
  it "should save new records and assign an ID and load the data as it was saved" do
    @player = Player.new(name: 'Brian Pattison')
    @player.id.nil?.should.equal true
    @player.save
    @player.id.should.equal 1
    @player.name.should.equal 'Brian Pattison'
    
    @score = Score.new(rank: 1, player_id: 1, value: 2000)
    @score.id.nil?.should.equal true
    @score.save
    @score.id.should.equal 1
    @score.rank.should.equal 1
    @score.player_id.should.equal 1
    @score.value.should.equal '2000'
    
    @score = Score.new(rank: 2, player_id: 20, value: 1000)
    @score.id.nil?.should.equal true
    @score.save
    @score.id.should.equal 2
    @score.rank.should.equal 2
    @score.player_id.should.equal 20
    @score.value.should.equal '1000'
  end
  
  it "should return an array of all records for a model using #all" do
    @scores = Score.all
    @scores.length.should.equal 2
  end
  
  it "should return an array of records from multiple ids" do
    @score = Score.new(rank: 3, player_id: 1, value: 530)
    @score.save
    
    @scores = Score.find([1, 3])
    @scores.length.should.equal 2
    @scores.first.id.should.equal 1
    @scores.first.value.should.equal '2000'
    @scores.last.id.should.equal 3
    @scores.last.value.should.equal '530'
  end
  
  it "should return an array of all records matching parameters given as a Hash" do
    @scores = Score.where(player_id: 1)
    @scores.length.should.equal 2
    @scores.first.value.should.equal '2000'
    @scores.last.value.should.equal '530'
  end
  
  it "should return record from has_many relationship" do
    @score = Score.find(1)
    @score.player_id.should.equal 1
    @score.player.id.should.equal 1
    @score.player.name.should.equal 'Brian Pattison'
  end
  
  it "should return records from has_many relationship" do
    @player = Player.find(1)
    @player.scores.length.should.equal 2
    @player.scores.first.rank.should.equal 1
    @player.scores.first.value.should.equal '2000'
  end
  
  it "should take a belongs_to object on initialize" do
    @player = Player.new(name: 'Kirsten Pattison')
    @player.save

    @score = Score.new(rank: 1, value: '50000', player: @player)
    @score.save
    @score.player.name.should.equal 'Kirsten Pattison'
    
    @player.scores.length.should.equal 1
    @player.scores.first.value.should.equal '50000'
  end
  
end