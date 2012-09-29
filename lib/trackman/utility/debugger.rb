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
        RestClient.post "#{@@server_url}/exceptions", :exception => { :message => ex.message, :backtrace => ex.backtrace }, :ssl_version => 'SSLv3'
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