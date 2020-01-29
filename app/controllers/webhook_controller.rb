class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle
    headers = request.headers
    event = headers['X-GitHub-Event']
    signature = headers['X-Hub-Signature']
    payload = request.raw_post

    head :ok if GithubHandler.new(event, payload, signature).handle
  end
end
