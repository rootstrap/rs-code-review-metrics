class GithubHandler
  def initialize(event, payload, signature)
    @event = event
    @payload = JSON.parse(payload)
    @raw_payload = payload
    @signature = signature
  end

  def handle
    return unless webhook_verified?

    case @event
    when "pull_request"
      case @payload["action"]
      when "review_requested"
        handle_review_request
        # when "review_request_removed"
        # TODO: Call the method to handle a review request removal
        # else unsupported
      end
      # else unsupported
    end
  end

  def handle_review_request
    owner = create_or_find_user(@payload["pull_request"]["user"])
    pr = create_or_find_pr(@payload["pull_request"])
    # Even if you select multiple reviewers at once, the webhook sends a post for every person selected
    # we can assume it is going to be a single user obj "requested_reviewer"
    participants = [create_or_find_user(@payload["requested_reviewer"])]
    ReviewRequest.create(data: @payload, owner: owner, users: participants, pull_request: pr)
  end

  def webhook_verified?
    digest = OpenSSL::HMAC.hexdigest("SHA1", ENV["GITHUB_ANALYZER_WEBHOOK_SECRET"], @raw_payload)
    ActiveSupport::SecurityUtils.secure_compare("sha1=#{digest}", @signature)
  end


  def create_or_find_user(json)
    User.create_or_find_by(
      github_id: json['id'], 
      node_id: json['node_id'],
      type: json['type'], 
      login: json['login']
    )
  end

  def create_or_find_pr(json)
    pr = {
      node_id: json['node_id'], 
      number: json['number'], 
      state: json['state'], 
      locked: json['locked'],
      title: json['title'], 
      body: json['body'], 
      closed_at: json['closed_at'],
      merged_at: json['merged_at'], 
      merged: json['merged'],
      draft: json['draft'], 
      github_id: json['id']
    }
    PullRequest.create_or_find_by(pr)
  end
end
