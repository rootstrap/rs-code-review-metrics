class GithubHandler
  include PayloadParser

  RETURNS = [
    SUCCESS = :success,
    FORBIDDEN = :forbidden,
    BAD_REQUEST = :bad_request
  ].freeze

  attr_reader :event, :payload, :raw_payload, :signature

  def initialize(event, payload, signature)
    @event = event
    @raw_payload = payload
    @payload = parse_payload(payload)
    @signature = signature
  end

  def handle
    return FORBIDDEN unless webhook_verified?

    case event
    when 'pull_request'
      case payload.action
      when 'opened'
        opened
      when 'review_requested'
        review_request
      when 'closed'
        closed
      when 'review_request_removed'
        review_removal
      else
        return BAD_REQUEST
      end
    else
      return BAD_REQUEST
    end
    SUCCESS
  rescue ActiveRecord::RecordInvalid
    BAD_REQUEST
  end

  def webhook_verified?
    digest = OpenSSL::HMAC.hexdigest('SHA1', ENV['GITHUB_ANALYZER_WEBHOOK_SECRET'], raw_payload)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", signature)
  end

  def opened
    GithubJobs::OpenedJob.perform_later(raw_payload)
  end

  def closed
    GithubJobs::ClosedJob.perform_later(raw_payload)
  end

  def review_request
    GithubJobs::ReviewRequestJob.perform_later(raw_payload)
  end

  def review_removal
    GithubJobs::ReviewRemovalJob.perform_later(raw_payload)
  end
end
