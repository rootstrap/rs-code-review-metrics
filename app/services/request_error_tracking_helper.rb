module RequestErrorTrackingHelper
  def track_request_error(exception)
    # TODO: ErrorHunter is not being maintained
    # ExceptionHunter.track(exception, custom_data: exception.response)
  end
end
