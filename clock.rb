
require File.expand_path('../config/boot',        __FILE__)  
require File.expand_path('../config/environment', __FILE__)
require 'clockwork'

module Clockwork
  every(1.day, 'daily_metrics_generator_job', at: '23:30') do
    ProcessReviewTurnaroundMetricsJob.perform_later
  end
end
