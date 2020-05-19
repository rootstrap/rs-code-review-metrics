if defined?(RailsPerformance)
  RailsPerformance.setup do |config|
    config.redis    = Redis.new(url: ENV.fetch('REDIS_PERFORMANCE_URL') { 'redis://localhost:6379/1' })
    config.duration = 4.hours
    config.enabled  = true
    if Rails.env.production?
      config.http_basic_authentication_enabled = true
      config.http_basic_authentication_user_name = ENV.fetch('PERFORMANCE_USERNAME')
      config.http_basic_authentication_password = ENV.fetch('PERFORMANCE_PASSWORD')
    end
  end
end
