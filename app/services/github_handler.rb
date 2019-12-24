class GithubHandler
  def initialize (event, payload)
    @event = event
    @payload = payload
  end

  def handle
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
    owner = User.create_or_find(@payload["pull_request"]["user"])
    pr = PullRequest.create_or_find(@payload["pull_request"])
    # Even if you select multiple reviewers at once, the webhook sends a post for every person selected
    # we can assume it is going to be a single user obj "requested_reviewer"
    participants = [ User.create_or_find(@payload["requested_reviewer"]) ]
    rev_req = ReviewRequest.create(data: @payload, owner: owner, users: participants, pull_request: pr)
  end
end
