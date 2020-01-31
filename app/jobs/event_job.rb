class EventJob < ApplicationJob
  queue_as :default

  def perform(payload, event)
    Event.create!(data: payload, name: event)
  end
end
