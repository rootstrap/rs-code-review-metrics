class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle
    @event = request.headers['X-GitHub-Event']
    @signature = request.headers['X-Hub-Signature']
    # this is needed because the action attr is replaced by rails' action param
    # and is lost on the params hash
    @payload = request.raw_post
    if GithubHandler.new(@event, @payload, @signature).handle.nil?
      head :forbidden
    else
      head :ok
    end
    
  rescue ActiveRecord::RecordInvalid
    head :bad_request
  end
end
