##
# Validates that the Event.name matches the class of the Event.handleable.
# For example if Event.handleable is a Events::PullRequest object the Event.name
# is expected to be 'pull_request'
class EventNameValidator < ActiveModel::Validator
  def validate(event)
    return if event.name == event.handleable.event_name
    event.errors[:event_name_validator] << 'Event.name must match Event.handleable type'
  end
end
