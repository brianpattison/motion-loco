describe "Loco::SQLiteAdapter" do
  
  it "should be defined" do
    Loco::SQLiteAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  Score.all.each do |score|
    score.destroy
  end
  App::Persistence["loco.scores.last_id"] = nil
  
  it "should save new records and assign an ID and load the data as it was saved" do
    @score = Score.new(rank: 1, user_id: 5, value: 2000)
    @score.id.nil?.should.equal true
    @score.save
    @score.id.should.equal 1
    @score.rank.should.equal 1
    @score.user_id.should.equal 5
    @score.value.should.equal '2000'
    
    @score = Score.new(rank: 2, user_id: '20', value: 1000)
    @score.id.nil?.should.equal true
    @score.save
    @score.id.should.equal 2
    @score.rank.should.equal 2
    @score.user_id.should.equal 20
    @score.value.should.equal '1000'
  end
  
  it "should return an array of all records for a model using #all" do
    @scores = Score.all
    @scores.length.should.equal 2
  end
  
  it "should return an array of records from multiple ids" do
    @score = Score.new(rank: 3, user_id: 5, value: 530)
    @score.save
    
    @scores = Score.find([1, 3])
    @scores.length.should.equal 2
    @scores.first.id.should.equal 1
    @scores.first.value.should.equal '2000'
    @scores.last.id.should.equal 3
    @scores.last.value.should.equal '530'
  end
  
  it "should return an array of all records matching parameters given as a Hash" do
    @scores = Score.where(user_id: 5)
    @scores.length.should.equal 2
    @scores.first.value.should.equal '2000'
    @scores.last.value.should.equal '530'
  end
  
end