if defined?(Rails) && ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
  puts ::Rails::VERSION::STRING 
  class Tasks < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../rails_generators/trackman/templates/*.rake')].each { |f| load f }
    end
  end
end