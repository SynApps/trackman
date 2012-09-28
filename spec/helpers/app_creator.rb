class AppCreator
  def self.get_config url
    response = RestClient.post url, :plan => 'test', :heroku_id => 123, :ssl_version => 'SSLv3'
    json = JSON.parse response

    trackman_url = json['config']['TRACKMAN_URL'].gsub('https', 'http')

    [[:server_url, trackman_url], [:site, "#{trackman_url}/assets"]]
  end

  def self.create
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    server = ENV['TRACKMAN_SERVER_URL']
    
    @@config = get_config "http://#{user}:#{pass}@#{server}/heroku/resources"

    Trackman::Assets::Persistence::Remote::ClassMethods.module_eval do
      #singleton = class << self; self; end
      @@config.each do |k, v|   
        alias_method "old_#{k}", k
        define_method(k, lambda { v })
      end
    end

    @@config
  end

  def self.reset
    RemoteAsset.all.each { |a| a.delete }

    Trackman::Assets::Persistence::Remote::ClassMethods.module_eval do
      #singleton = class << self; self; end
      @@config.each do |k,v|
        alias_method k, "old_#{k}"
      end
    end
  end
end