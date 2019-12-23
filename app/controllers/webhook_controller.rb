class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle
    @event = request.headers['X-GitHub-Event']
    # this is needed because the action attr is replaced by rails' action param, and is lost on the params hash
    @payload = JSON.parse(request.raw_post)
    GithubHandler.new(@event, @payload).handle
    head :ok
  end
end
