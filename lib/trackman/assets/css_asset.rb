module Trackman
  module Assets
    class CssAsset < Asset
      include Components::CompositeAsset

      protected
		alias children_paths inner_css_paths
		
    end
  end
end