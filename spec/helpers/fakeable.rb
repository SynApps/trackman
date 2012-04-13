module Fakeable
  def initialize attributes = {}
    super
    self.pre_path = attributes[:pre_path]
  end

  attr_reader :pre_path

  def validate_path?
    false
  end

  def to_remote
    Trackman::Assets::FakeRemoteAsset.new(:path => path, :pre_path => pre_path)
  end

  def file
    File.open(pre_path + path)
  end
end

module Trackman::Assets
  class Asset
    include Fakeable
  end
  class HtmlAsset
    include Fakeable
  end
  class Rails32Asset
    include Fakeable
  end
end