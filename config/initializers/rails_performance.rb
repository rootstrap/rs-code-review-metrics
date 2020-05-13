if defined?(RailsPerformance)
  RailsPerformance.setup do |config|
    config.redis    = Redis.new(url: ENV.fetch('REDIS_PERFORMANCE_URL') { 'redis://localhost:6379/1' })
    config.duration = 4.hours
    config.enabled  = true
    config.http_basic_authentication_enabled = false
  end
end
