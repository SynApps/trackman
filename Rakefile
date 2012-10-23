require "bundler/gem_tasks"
require 'rspec/core/rake_task'


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

namespace :setup do
  namespace :rails32 do
    desc "runs rails new for a given name and removes useless files"
    task :fixture, :name do |t, args| 
      name = response = args[:name]
      puts "rails _3.2.0_ new spec/fixtures/rails32/#{name} -G -O -T"
      `rails _3.2.0_ new spec/fixtures/rails32/#{name} -G -O -T`
    end
  end

  namespace :rails309 do
    desc "runs rails new for a given name and removes useless files"
    task :fixture, :name do |t, args| 
      name = response = args[:name]
      puts "rails _3.0.9_ new spec/fixtures/rails309/#{name} -G -O -T"
      `rails _3.0.9_ new ./lib/trackman/assets/remote_asset.rb:74:inspec/fixtures/rails309/#{name} -G -O -T`
    end
  end

  namespace :rails2311 do
    desc "runs rails new for a given name and removes useless files"
    task :fixture, :name do |t, args| 
      name = response = args[:name]
      puts "cp spec/fixtures/rails2311/template spec/fixtures/rails2311/#{name}"
      `cp -r spec/fixtures/rails2311/template spec/fixtures/rails2311/#{name}`
    end
  end
end

namespace :ci do 
  task :server do 
    to_unset = ENV.select{|k,v| k.include? 'BUNDLE' }
    to_unset.each_key { |k| to_unset[k] = nil }
    
    pid = spawn(to_unset, "update_trackman_server")
    Process.wait(pid)
    
    spawn(to_unset, "start_trackman_server")
    sleep(10)
  end

  task :tests => ['ci:bi', 'ci:server', :spec] do
    result = `lsof -i :3000`
    pid = result.match(/ruby\ +(\d+)/)[1].to_i

    puts "Killing #{pid}"
    Process.kill 9, pid
  end
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = Dir['spec'].sort
  task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }
  task.rspec_opts << '--color -f d'
end

