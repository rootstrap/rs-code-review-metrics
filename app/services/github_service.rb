class GithubService < BaseService
  def initialize(payload:, event:)
    @payload = payload
    @event = event
  end

  def call
    handle_request
  end

  private

  def handle_request
    build_project
    handle_event
    handle_action
  end

  def build_project
    repo = @payload['repository']
    @project = Project.find_or_create_by!(github_id: repo['id']) do |pj|
      pj.name = repo['name']
      pj.description = repo['description']
    end
  end

  def handle_event
    event = Event.create!(project: @project, data: @payload, name: @event)
    raise StandardError unless handleable_event?

    @entity = find_or_create_event_type
    event.update!(handleable: @entity)
  end

  def handleable_event?
    Event::TYPES.include?(@event)
  end

  def find_or_create_event_type
    EventBuilders.const_get(@event.classify).call(payload: @payload, event: @event)
  end

  def handle_action
    ActionHandlers.const_get(@event.classify).call(payload: @payload,
                                                   event: @event,
                                                   entity: @entity)
  end
end
