require 'spec_helper'

class Rails32ResolverTest
  include Rails32Resolver
end

describe Trackman::Path::Rails32Resolver do  
  
  before :all do
    @test = Rails32ResolverTest.new
  end

  it "does not throw when sprockets throws a FileNotFound" do
    sprocket = double "SprocketEnvironment"
    sprocket.stub(:resolve).and_raise(Sprockets::FileNotFound)
    
    @test.stub(:prepare_for_sprocket).and_return('some/path')
    @test.stub(:sprockets).and_return(sprocket)

    lambda { @test.translate 'some/path', 'path/to/my/parent' }.should_not raise_error
  end
  
  it "can resolve public assets when sprocket cannot find anything" do
    sprocket = double "SprocketEnvironment"
    sprocket.stub(:paths).and_return([])
    sprocket.stub(:resolve).and_raise Sprockets::FileNotFound

    @test.stub(:sprockets).and_return(sprocket)
    
    result = @test.translate 'favicon.ico', 'spec/fixtures/rails32/happy-path/public/503.html'
    
    result.should == 'spec/fixtures/rails32/happy-path/public/favicon.ico'
  end

  it "returns nil it cannot find anything" do
    sprocket = double "SprocketEnvironment"
    sprocket.stub(:paths).and_return([])
    sprocket.stub(:resolve).and_raise Sprockets::FileNotFound

    @test.stub(:sprockets).and_return(sprocket)
    
    result = @test.translate 'non-existent.jpg', 'spec/fixtures/rails32/happy-path/public/503.html'
    
    result.should be_nil
  end
end