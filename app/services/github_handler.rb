class GithubHandler

  RETURNS = [
    SUCCESS = :success,
    FORBIDDEN = :forbidden,
    BAD_REQUEST = :bad_request
  ].freeze

  attr_reader :event, :payload, :signature

  def initialize(event, payload, signature)
    @event = event
    @payload = payload
    @signature = signature
  end

  def handle
    return FORBIDDEN unless webhook_verified?

    case event
    when 'pull_request'
      case payload['action']
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
    digest = OpenSSL::HMAC.hexdigest('SHA1', ENV['GITHUB_ANALYZER_WEBHOOK_SECRET'], payload)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", signature)
  end

  def opened
    GithubJobs::OpenedJob.perform_later(payload)
  end

  def closed
    GithubJobs::ClosedJob.perform_later(payload)
  end

  def review_request
    GithubJobs::ReviewRequestJob.perform_later(payload)
  end

  def review_removal
    GithubJobs::ReviewRemovalJob.perform_later(payload)
  end
end
