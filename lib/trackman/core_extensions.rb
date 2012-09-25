
class String
  def trackman_underscore
    word = dup
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end

class Symbol
  def trackman_underscore
    to_s.trackman_underscore
  end
end

#ruby 1.8.7 does not take blocks (this fixes it) -- used in Asset.all
if RUBY_VERSION !~ /^1\.9/
  class Array
    def uniq
      ret, keys = [], []
      each do |x|
        key = block_given? ? yield(x) : x
        unless keys.include? key
          ret << x
          keys << key
        end
      end
      ret
    end
  end
end

