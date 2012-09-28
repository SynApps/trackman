require 'logger'
require 'rest-client'

module Trackman
  module Utility
    class Debugger
      @@server_url = ENV['TRACKMAN_URL']

      def self.debug_mode?
        !ENV['TRACKMAN_DEBUG_MODE'].nil? && ENV['TRACKMAN_DEBUG_MODE'] == 'true'
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

RestClient.log = Logger.new(STDOUT) if Trackman::Utility::Debugger.debug_mode?