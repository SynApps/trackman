require 'spec_helper'
require 'bombero_client'

describe BomberoClient::Assets::Asset do
  it "should raise an exception if the path is not good" do 
    wrong_path = "./wrong_path.html"
    lambda { BomberoClient::Assets::Asset.new(wrong_path) }.should raise_error BomberoClient::Assets::AssetNotFoundError
  end
  
  it "should be equal if the path is the same" do
    path = "./spec/spec_helper.rb"

    asset1 = BomberoClient::Assets::Asset.new(path)
    asset2 = BomberoClient::Assets::Asset.new(path)

    asset1.should == asset2
  end  
end