require 'rubygems'
require 'bundler/setup'

require File.expand_path('../trackman/utility/core_extensions', __FILE__)
require File.expand_path('../trackman/utility/railtie', __FILE__)

module Trackman
  #TODO do something better than this to share the scope
  def self.autoloads path, items
    items.each do |s|
      if block_given? 
        yield(s, "#{path}/#{s.trackman_underscore}" ) 
      else
        autoload s, "#{path}/#{s.trackman_underscore}" 
      end
    end
  end

  autoloads 'trackman', [:Assets, :Configuration, :Scaffold, :Components, :Errors, :Path, :Utility]
end