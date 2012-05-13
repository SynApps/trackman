class AppCreator
  def self.get_config
    RemoteAsset.class_variables.inject({}) do |carry, e| 
      carry.merge!({e => RemoteAsset.class_variable_get(e)})
    end
  end

  def self.create
    #  @@user = ENV['TRACKMAN_USER']
    #  @@pass = ENV['TRACKMAN_PASSWORD']
    #  @@app_id = ENV['TRACKMAN_APP_ID']
    #  @@server = ENV['TRACKMAN_SERVER_URL']

    #  @@site = "http://#{@@user}:#{@@pass}@#{@@server}/heroku/resources/#{@@app_id}/assets"
    
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    
    server = RemoteAsset.class_variable_get :@@server
    url = "http://#{user}:#{pass}@#{server}/heroku/resources"

    response = RestClient.post url, :plan => 'test', :heroku_id => 123 
    json = JSON.parse response

    user = json['config']['TRACKMAN_USER']
    pass = json['config']['TRACKMAN_PASSWORD']
    id = json['id']
    site = "http://#{user}:#{pass}@#{server}/heroku/resources/#{id}/assets"
    
    RemoteAsset.class_variable_set(:@@user, user)
    RemoteAsset.class_variable_set(:@@pass, pass)
    RemoteAsset.class_variable_set(:@@app_id, id)
    RemoteAsset.class_variable_set(:@@site, site)

    puts "8888888888888888888 APP ID #{id}"
    get_config
  end

  def self.reset
    @@old_config.each do |k,v|
      RemoteAsset.class_variable_set(k, v)
    end
  end

  @@old_config = get_config
end