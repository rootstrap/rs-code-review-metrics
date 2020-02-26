module Events
  ##
  # This Module adds common method to all ApplicationRecord modeling Events
  module EventRecord
    def event_name
      self.class.name.demodulize.underscore
    end
  end
end
