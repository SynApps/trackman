require "bundler/gem_tasks"


desc "creates a new app to the server and outputs the credentials"
task :create_app do
  require 'trackman'
  RemoteAsset = Trackman::Assets::RemoteAsset  

  user = ENV['HEROKU_USERNAME']
  pass = ENV['HEROKU_PASSWORD']
  server = RemoteAsset.class_variable_get :@@server

  url = "http://#{user}:#{pass}@#{server}/heroku/resources"
  puts "\nPosting on : #{url}\n\n"
  response = RestClient.post url, :plan => 'test', :heroku_id => 123 
  json = JSON.parse response

  puts "export TRACKMAN_USER=#{json['config']['TRACKMAN_USER']}"
  puts "export TRACKMAN_PASSWORD=#{json['config']['TRACKMAN_PASSWORD']}"
  puts "export TRACKMAN_APP_ID=#{json['id']}\n\n"
  
  puts "Have fun!"
end
