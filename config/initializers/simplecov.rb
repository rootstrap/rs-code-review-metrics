if Rails.env.test?
  require 'simplecov'
  SimpleCov.start :rails do
    add_group 'Services', 'app/services'
    add_filter 'spec/'
    add_filter 'app/admin'
    add_filter 'lib/'
    add_filter 'app/mailers'
    add_filter 'app/channels'
  end
end
