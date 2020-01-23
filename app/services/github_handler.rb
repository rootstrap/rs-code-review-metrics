class GithubHandler
  RETURNS = [
    SUCCESS = :success,
    FORBIDDEN = :forbidden,
    BAD_REQUEST = :bad_request
  ].freeze

  attr_reader :event, :payload, :raw_payload, :signature

  def initialize(event, payload, signature)
    @event = event
    @raw_payload = payload
    @payload = parse_payload
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
    pr_data = payload.pull_request
    PullRequest.create!(
      node_id: pr_data.node_id,
      number: pr_data.number,
      state: pr_data.state,
      locked: pr_data.locked,
      draft: pr_data.draft,
      title: pr_data.title,
      body: pr_data.body,
      closed_at: pr_data.closed_at,
      merged_at: pr_data.merged_at,
      merged: pr_data.merged,
      github_id: pr_data.id
    )
  end

  def closed
    find_pr.closed!
  end

  def review_request
    owner = create_or_find_user(payload.pull_request.user)
    reviewer = create_or_find_user(payload.requested_reviewer)
    find_pr.review_requests.create!(data: payload, owner: owner, reviewer: reviewer)
  end

  def review_removal
    reviewer = create_or_find_user(payload.requested_reviewer)
    find_pr.review_requests.find_by!(reviewer: reviewer).removed!
  end

  def create_or_find_user(user_data)
    User.find_by(github_id: user_data.id) ||
      User.create!(
        node_id: user_data.node_id,
        login: user_data.login,
        github_id: user_data.id
      )
  end

  def find_pr
    PullRequest.find_by!(github_id: payload.pull_request.id)
  end

  def parse_payload
    JSON.parse(raw_payload.to_json, object_class: OpenStruct)
  end
end
