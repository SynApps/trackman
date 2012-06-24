class AppCreator
  def self.get_config url
    response = RestClient.post url, :plan => 'test', :heroku_id => 123 
    json = JSON.parse response

    trackman_url = json['config']['TRACKMAN_URL'].gsub('https', 'http')

    [[:@@server_url, trackman_url], [:@@site, "#{trackman_url}/assets"]]
  end

  def self.create
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    server = ENV['TRACKMAN_SERVER_URL']

    @@config = get_config "http://#{user}:#{pass}@#{server}/heroku/resources"

    @@config.each do |s, v| 
      RemoteAsset.send(:class_variable_set, s, v)
    end
  end

  def self.reset
    @@config.each do |k,v|
      RemoteAsset.send(:class_variable_set, k, v)
    end
  end
end