module ActionHandlers
  class PullRequest < ActionHandler
    ACTIONS = %w[open review_requested closed \
                 review_request_removed].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def open
      @entity.open!
      @entity.update!(opened_at: Time.current)
    end

    def merged
      @entity.update!(merged_at: Time.current)
    end

    def closed
      merged if @payload['pull_request']['merged'] == true
      @entity.closed!
      @entity.update!(closed_at: Time.current)
    end

    def review_request_removed
      pr_data = @payload['pull_request']
      reviewers_github_id = pr_data['requested_reviewers'].map { |reviewer| reviewer['id'] }
      owner_github_id = pr_data['user']['id']
      remove_review_requests(reviewers_github_id)
    end

    def review_requested
      pr_data = @payload['pull_request']
      owner = find_or_create_user(pr_data['user'])
      pr_data['requested_reviewers'].each do |raw_reviewer|
        reviewer = find_or_create_user(raw_reviewer)
        @entity.review_requests.create!(owner: owner, reviewer: reviewer, state: 'active')
      rescue ActiveRecord::RecordInvalid => e
        raise unless e.message == 'Validation failed: Pull request has already been taken'
      end
    end

    def remove_review_requests(reviewers)
      @entity.review_requests
             .includes(:owner)
             .where.not(reviewer: User.where(github_id: reviewers))
             .each(&:removed!)
    end
  end
end
