module Trackman
  module Assets
    module Diffable
      def diff local, remote 
        { 
          :create => local.select{|a| remote.all? { |s| a.path != s.path } }.map{|a| a.to_remote }.to_a, 
          :update => remote.select{|a| local.any?{ |s| a.path == s.path && a.hash != s.hash }}.to_a,  
          :delete => remote.select{|a| local.all? { |s| s.path != a.path } }.to_a
        }        
      end
    end
  end
end