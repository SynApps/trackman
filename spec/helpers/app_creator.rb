class AppCreator
  def self.get_config
    RemoteAsset.class_variables.inject({}) do |carry, e| 
      carry.merge!({e => RemoteAsset.send(:class_variable_get, e)})
    end
  end

  def self.create
    user = ENV['HEROKU_USERNAME']
    pass = ENV['HEROKU_PASSWORD']
    
    server = RemoteAsset.send(:class_variable_get, :@@server)
    url = "http://#{user}:#{pass}@#{server}/heroku/resources"

    response = RestClient.post url, :plan => 'test', :heroku_id => 123 
    json = JSON.parse response

    user = json['config']['TRACKMAN_USER']
    pass = json['config']['TRACKMAN_PASSWORD']
    id = json['id']
    site = "http://#{user}:#{pass}@#{server}/heroku/resources/#{id}/assets"
    

    [[:@@user,user], [:@@pass, pass], [:@@app_id, id], [:@@site, site]].each do |s, v| 
      RemoteAsset.send(:class_variable_set, s, v)
    end

    get_config
  end

  def self.reset
    @@old_config.each do |k,v|
      RemoteAsset.send(:class_variable_set, k, v)
    end
  end

  @@old_config = get_config
end