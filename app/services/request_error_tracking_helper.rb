module RequestErrorTrackingHelper
  def track_request_error(exception)
    ExceptionHunter.track(exception, custom_data: exception.response)
  end
end
