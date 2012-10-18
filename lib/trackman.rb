require 'rubygems'
require 'bundler/setup'

require File.expand_path("../trackman/utility/core_extensions", __FILE__)

module Trackman
  autoload :Assets, 'trackman/assets'
  autoload :Scaffold, 'trackman/scaffold'
  autoload :Components, 'trackman/components'
  autoload :Errors, 'trackman/errors'
  autoload :Path, 'trackman/path'
  autoload :Utility, 'trackman/utility'
  autoload :Urls, 'trackman/urls'

end
require File.expand_path("../trackman/version", __FILE__)
require File.expand_path("../trackman/utility/debugger", __FILE__)
require File.expand_path("../trackman/utility/railtie", __FILE__)
