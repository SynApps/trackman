module Trackman
  module Assets
    class CssAsset < Asset
      include CompositeAsset, Trackman::Urls::CssParser

      protected
		    def children_paths
		      @children ||= parse_css(data)
        end
    end
  end
end