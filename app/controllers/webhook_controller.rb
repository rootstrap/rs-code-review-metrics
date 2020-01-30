class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_params

  def handle
    return head :ok if Event.resolve(@payload)

    head 400
  end

  private

  def set_params
    head 403 && return unless webhook_verified?

    @headers = request.headers
    @signature = @headers['X-Hub-Signature']
    @payload = JSON.parse(request.raw_post)
                   .merge(event: @headers['X-GitHub-Event'])
  end

  def webhook_verified?
    digest = OpenSSL::HMAC.hexdigest('SHA1', ENV['GITHUB_ANALYZER_WEBHOOK_SECRET'], @payload)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", @signature)
  end
end
