require 'digest/md5'
 
module BomberoClient
  module Assets
    module Hashable
      
      def file
        @file ||= File.open(path)
      end
      def data
        @data ||= read_file
      end

      def hash
        Digest::MD5.hexdigest(data)
      end
      
      protected
        def read_file
          begin
            return file.read
          rescue
            return nil
          ensure
            file.close 
          end    
        end      
    end
  end
end