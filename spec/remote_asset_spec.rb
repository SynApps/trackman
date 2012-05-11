require 'spec_helper'

describe Trackman::Assets::RemoteAsset do  
  before :all do
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    server = RemoteAsset.class_variable_get :@@server

    response = RestClient.post "http://#{user}:#{pass}@#{server}/heroku/resources", :plan => 'test', :heroku_id => 123 
    json = JSON.parse response
    
    user = json['config']['TRACKMAN_USER']
    pass = json['config']['TRACKMAN_PASSWORD']
    app_id = json['id']

    RemoteAsset.class_variable_set :@@app_id, app_id 
    RemoteAsset.class_variable_set :@@user, user
    RemoteAsset.class_variable_set :@@pass, pass
    RemoteAsset.class_variable_set :@@site, "http://#{user}:#{pass}@#{server}/heroku/resources/#{app_id}/assets"
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
    expected = ['spec/test_data/y.css', 'spec/test_data/a.js', '/public/503-error.html', '/public/503.html', 'spec/test_data/sample.html']
    
    assets = ['spec/test_data/y.css', 'spec/test_data/a.js', 'spec/test_data/sample.html']
      .map { |f| RemoteAsset.new(:path => f) }
      .to_a

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
    configs = {
      '@@server' => 'TRACKMAN_SERVER_URL', 
      '@@user' => 'TRACKMAN_USER', 
      '@@pass' => 'TRACKMAN_PASSWORD', 
      '@@app_id' => 'TRACKMAN_APP_ID'
    }
    begin
      configs.each {|k,v| RemoteAsset.class_variable_set k, nil }
      configs.each do |k,v|
        lambda { RemoteAsset.new(:path => 'spec/test_data/a.js') }.should raise_error(Trackman::Assets::Errors::ConfigNotFoundError)
        RemoteAsset.class_variable_set k, ENV[v]
      end
    ensure 
      configs.each {|k,v| RemoteAsset.class_variable_set k, ENV[v] }
    end
  end
end