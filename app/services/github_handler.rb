class GithubHandler
  attr_reader :event, :payload, :signature

  def initialize(event, payload, signature)
    @event = event
    @payload = JSON.parse(payload)
    @signature = signature
  end

  def handle
    Event.create!(data: payload, name: event).handle if webhook_verified?
  end

  def webhook_verified?
    digest = OpenSSL::HMAC.hexdigest('SHA1', ENV['GITHUB_ANALYZER_WEBHOOK_SECRET'], payload)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", signature)
  end
end
