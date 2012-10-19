module Trackman
  module Components
    module Diffable
      def diff local, remote 
        to_create = local.select{|a| remote.all? { |s| a.path != s.path } }.map{|a| a.to_remote }
        
        { 
          :create => to_create, 
          :update => define_update(local, remote),  
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

        def define_update local, remote
          to_update = local.select do |l| 
            remote.any? do |r| 
              path_eql = a.path == s.path
              hash_eql = a.file_hash == s.file_hash 
              vp_eql = a.virtual_path == s.virtual_path

              path_eql && (!hash_eql || !vp_eql)
            end
          end

          to_update.map do |a| 
            sibling = remote.select{|x| x.path == a.path }.first
            a.to_remote(sibling.id)
          end
        end

    end
  end
end