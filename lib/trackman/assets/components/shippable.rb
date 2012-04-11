module Trackman
  module Assets
    module Components
      module Shippable
        def ship diff
          to_ship = diff.inject([])do |memo, (k, v)| 
            memo + v.map{ |x| {:proc => build_proc(k, x), :value => x} }
          end
          
          to_ship.sort_by{ |x| x[:value] }.each do |x| 
            x[:proc].call
          end 
        end
      private 
        def build_proc symbol, instance 
          case symbol
          when :update
            proc = Proc.new { instance.update! }
          when :create
            proc = Proc.new { instance.create! }
          when :delete
            proc = Proc.new { instance.delete }
          else
            raise "something is wrong."
          end
          proc
        end
      end
    end
  end
end