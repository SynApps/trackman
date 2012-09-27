require 'digest/md5'
 
module Trackman
  module Components
    module Hashable
      def data
        @data ||= read_file(path)
      end

      def file_hash
        @file_hash ||= (data.nil? ? "" : Digest::MD5.hexdigest(data))
      end
      
      protected
        def read_file(file_path)
          begin
            file = File.open(file_path)
            return file.read
          rescue
            return nil
          ensure
            file.close unless file.nil?
          end    
        end
    end      
  end
end