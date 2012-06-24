class Debugger
  def self.debug_mode?
    !ENV['TRACKMAN_DEBUG_MODE'].nil? && ENV['TRACKMAN_DEBUG_MODE'] == 'true'
  end

  def self.trace data
    puts data if debug_mode?
  end
end