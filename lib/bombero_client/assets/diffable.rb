module BomberoClient
  module Assets
    module Diffable
      def diff local, remote 
        { 
          :create => local.select{|a| remote.all? { |s| a.path != s.path } }.to_a, 
          :update => local.select{|a| remote.any?{ |s| a.path == s.path && a.hash != s.hash } }.to_a,  
          :delete => remote.select{|a| local.all? { |s| s.path != a.path } }.to_a
        }        
      end
    end
  end
end