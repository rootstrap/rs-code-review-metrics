class EventBuilder < BaseService
  def initialize(payload:, event:)
    @payload = payload
    @event = event
  end

  def call
    build
  end

  private

  def find_pull_request
    Events::PullRequest.find_by!(github_id: @payload['pull_request']['id'])
  end
end
