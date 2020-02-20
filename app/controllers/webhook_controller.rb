class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_params

  def handle
    RequestHandlerJob.perform_later(@payload, @event)

    head :ok
  end

  private

  def set_params
    @headers = request.headers
    @signature = @headers['X-Hub-Signature']
    @payload = JSON.parse(request.request_parameters['payload'])
    @event = @headers['X-GitHub-Event']

    head :forbidden && return unless webhook_verified?
  end

  def webhook_verified?
    digest = OpenSSL::HMAC.hexdigest('SHA1', ENV['GITHUB_ANALYZER_WEBHOOK_SECRET'], @payload.to_s)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", @signature)
  end
end
