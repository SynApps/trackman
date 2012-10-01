require 'logger'
require 'rest-client'

module Trackman
  module Utility
    class Debugger
      @@server_url = ENV['TRACKMAN_URL']

      def self.debug_mode?
        @@debug ||= ENV['TRACKMAN_DEBUG_MODE'] == 'true'
      end

      def self.trace data
        puts data if debug_mode?
      end

      def self.log_exception ex
        to_send = {
          :ruby_version => "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}",
          :gem_version => Trackman::VERSION,
          :rails_version => defined?(Rails) ? ::Rails::VERSION::STRING : 'rails not defined',
          :bundle => `bundle list`.split("\n"),
          :exception => { :class => ex.class.name, :message => ex.message, :backtrace => ex.backtrace },
          :local => Trackman::Assets::Asset.all.map{|a| a.to_s },
          :remote => Trackman::Assets::RemoteAsset.all.map{|a| a.to_s }
        }
        send_data to_send
      end
      
      def self.send_data data
        RestClient.post "#{@@server_url}/exceptions", data, :ssl_version => 'SSLv3'
      end
    end
  end
end

if Trackman::Utility::Debugger.debug_mode?
  RestClient.log = Logger.new(STDOUT) 

  #loads module first
  Trackman::Components::Diffable

  module Trackman
    module Components
      module Diffable
        alias old_diff diff
        
        def diff local, remote 
          result = old_diff local, remote
          Trackman::Utility::Debugger.trace "Diff result:\n#{result.inspect}"
          result
        end
      end
    end
  end
end