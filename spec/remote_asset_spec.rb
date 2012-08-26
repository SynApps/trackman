require 'spec_helper'

describe Trackman::Assets::RemoteAsset do  
  before :all do
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    server = ENV['TRACKMAN_SERVER_URL']

    response = RestClient.post "http://#{user}:#{pass}@#{server}/heroku/resources", :plan => 'test', :heroku_id => 123 
    json = JSON.parse response
    @trackman_url = json['config']['TRACKMAN_URL'].gsub('https', 'http')
    
    puts @trackman_url
    @config = [[:@@server_url, @trackman_url], [:@@site, "#{@trackman_url}/assets"]]
    @config.each do |s, v|
      RemoteAsset.send(:class_variable_set, s, v)
    end
  end
  
  after :each do
    RemoteAsset.all.each do |a|
      a.delete
    end

    File.open('spec/test_data/y.css', 'w') {|f| f.write @old_file } unless @old_file.nil?
  end

  it "creates assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/test2.png')
    expected.create!
    
    actual = RemoteAsset.find expected.id

    actual.should eq(expected)
  end

  it "deletes assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/y.css')
    expected.create!
    
    expected.delete
    
    lambda { RemoteAsset.find expected.id }.should raise_error(RestClient::ResourceNotFound)
  end
  
  it "returns all assets on the server" do
    expected = ['spec/test_data/a.js', 'spec/test_data/y.css', 'public/503-error.html', 'public/503.html', 'spec/test_data/sample.html']
    
    assets = ['spec/test_data/a.js', 'spec/test_data/y.css', 'spec/test_data/sample.html'].map { |f| RemoteAsset.new(:path => f) }

    assets.each{|f| f.create! }

    RemoteAsset.all.map{|a| a.path.to_s }.should eq(expected)
  end

  it "updates assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/y.css')
    
    expected.create! 
    
    @old_file = File.open(expected.path) { |f| f.read }
    File.open(expected.path, 'w') { |f| f.write "wassup cutie pie?" }
  
    expected.update!
    actual = RemoteAsset.find(expected.id)

    actual.should eq(expected)
  end 

  it "throws if a config is missing" do
    begin
      @config.each {|k,v| RemoteAsset.send(:class_variable_set, k, nil) }
      @config.each do |k,v|
        lambda { RemoteAsset.new(:path => 'spec/test_data/a.js') }.should raise_error(Trackman::Assets::Errors::ConfigNotFoundError)
      end
    ensure
      @config.each {|k,v| RemoteAsset.send(:class_variable_set, k, v) }
    end
  end
end