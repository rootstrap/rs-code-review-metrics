class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :format_params

  def handle
    Event.resolve(@payload) if webhook_verified?
  end

  private

  def format_params
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
