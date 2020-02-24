module SimplePager
end

if defined?(Rails::Railtie)
  require 'simple_pager/railtie'
elsif defined?(Rails::Initializer)
  raise "simple_pager 0.2 is not compatible with Rails 2.3 or older"
end
