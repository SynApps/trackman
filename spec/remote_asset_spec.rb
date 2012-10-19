require 'spec_helper'
require 'helpers/app_creator'

describe Trackman::Assets::RemoteAsset do  
  before :each do
    @old_file = nil
    @config = AppCreator.create
  end
  
  after :each do
    AppCreator.reset
    @config = nil
    File.open('spec/test_data/y.css', 'w') {|f| f.write @old_file } unless @old_file.nil?
  end

  it "creates assets on the server" do
    expected = RemoteAsset.create(:path => 'spec/test_data/test2.png', :virtual_path => 'spec/test_data/test2.png')
    expected.insert
    
    actual = RemoteAsset.find expected.id

    actual.should eq(expected)
  end

  it "deletes assets on the server" do
    expected = RemoteAsset.create(:path => 'spec/test_data/y.css')
    expected.insert
    
    expected.delete
    
    lambda { RemoteAsset.find expected.id }.should raise_error(RestClient::ResourceNotFound)
  end
  
  it "returns all assets on the server" do
    expected = [
      'spec/test_data/a.js', 'spec/test_data/y.css', 
      'public/503-error.html', 'public/503.html', 
      'spec/test_data/sample.html'
    ]
    
    assets = ['spec/test_data/a.js', 'spec/test_data/y.css', 'spec/test_data/sample.html'].map do |f| 
      RemoteAsset.create(:path => f) 
    end

    assets.each{|f| f.insert }

    RemoteAsset.all.map{|a| a.path.to_s }.should eq(expected)
  end

  it "updates assets on the server" do
    expected = RemoteAsset.create(:path => 'spec/test_data/y.css', :virtual_path => 'spec/test_data/y.css')
    
    expected.insert
    
    @old_file = File.open(expected.path) { |f| f.read }
    File.open(expected.path, 'w') { |f| f.write "wassup cutie pie?" }
  
    expected.update
    actual = RemoteAsset.find(expected.id)

    actual.should eq(expected)
  end 

  it "throws if a config is missing" do
    config = @config
    begin
      Trackman::Assets::Persistence::Remote::ClassMethods.module_eval do
        config.each do |k,v| 
          alias_method "temp_#{k}", k
          define_method(k, lambda{ nil }) 
        end
      end
      lambda { RemoteAsset.create(:path => 'spec/test_data/a.js') }.should raise_error(Trackman::Errors::ConfigNotFoundError)
    ensure
      Trackman::Assets::Persistence::Remote::ClassMethods.module_eval do
        config.each do |k,v| 
          alias_method k, "temp_#{k}"
        end
      end
    end
  end
end