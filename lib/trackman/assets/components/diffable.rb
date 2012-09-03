module Trackman
  module Assets
    module Components
      module Diffable
        def diff local, remote 
          to_create = local.select{|a| remote.all? { |s| a.path != s.path } }.map{|a| a.to_remote }
          
          { 
            :create => to_create, 
            :update => remote.select{|a| local.any?{ |s| a.path == s.path && a.file_hash != s.file_hash }},  
            :delete => define_deleted(local, remote) do |a| 
              to_create.any?{ |c| c.path.basename == a.path.basename }
            end
          }
        end

        private
          # will not delete an html for now. 
          # this behaviour is to avoid the removal of the default templates.
          def define_deleted local, remote
            to_delete = remote.select do |a| 
              local.all? { |s| s.path != a.path } 
            end

            to_delete.reject{|a| a.path.to_s =~ /.html$/ }.to_a
          end
      end
    end
  end
end