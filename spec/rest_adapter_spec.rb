motion_require 'adapter_test_helper'

describe "Loco::RESTAdapter" do
  
  it "should be defined" do
    Loco::RESTAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should accept a base URL on initialize" do
    @adapter = Loco::RESTAdapter.new('http://localhost:3000/')
    @adapter.url.should.equal 'http://localhost:3000'
  end
  
  it "should raise an error if you don't specify the base URL" do
    should.raise ArgumentError do
      @adapter = Loco::RESTAdapter.new
      @adapter.url
    end
  end
  
  it "should pass all adapter tests" do
    AdapterTestHelper.run('Loco::RESTAdapter', { async: true }, 'http://localhost:3000').should.equal true
  end
  
  it "should transform a UTC datetime" do
    transforms = Loco::Adapter.get_transforms[:datetime]
    date = '2013-09-27T18:34:38Z'
    
    date = transforms[:deserialize].call(date)
    date.is_a?(NSDate).should.equal true
    
    date = transforms[:serialize].call(date)
    date.should.equal '2013-09-27T18:34:38Z'
  end
  
end