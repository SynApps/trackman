require "rubygems"
require "bundler/setup"
require 'tasks'

module Trackman
  autoload :RackMiddleware, 'trackman/rack_middleware'
  autoload :Assets, 'trackman/assets'  
end 

autoload :Debugger, 'trackman/debugger'

if defined?(Rails)
  if ::Rails::VERSION::STRING =~ /^2\.[1-9]/
    unless Rails.class_variable_get(:@@configuration).nil?  
      Rails.configuration.middleware.use Trackman::RackMiddleware
    end 
  elsif ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
    require "trackman/railtie"
  end
end


#ruby 1.8.7 does not take blocks (this fixes it) -- used in Asset.all
if RUBY_VERSION !~ /^1\.9/
  class Array
    def uniq
      ret, keys = [], []
      each do |x|
        key = block_given? ? yield(x) : x
        unless keys.include? key
          ret << x
          keys << key
        end
      end
      ret
    end
  end
end