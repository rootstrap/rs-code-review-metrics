# The intention of this script is to reprocess all the events stored in Events table all over again.
# This script should be used whenever there are changes in the event types models.

class EventsProcessor
  class << self
    def process
      errors = []

      retrieve_reviews do |event|
        Projects::Builder.call(event.data['repository'])
        event_name = event.data['event']
        process_event(event, event_name) if handleable_event?(event_name)
      rescue StandardError => e
        errors << error_msg(event, e)
      end
      Rails.logger.error errors unless errors.empty?
    end

    def retrieve_reviews
      Event.all.find_each.lazy.each do |event|
        yield(event)
      end
    end

    def process_event(event, event_name)
      payload = event.data
      event_class = event_name.classify

      entity = find_or_create_event_type(event_class, payload)
      handle_action(event_class, payload, entity)
    end

    def error_msg(event, error)
      "#{event.name.humanize} with ID: '#{event.id}', failed with '#{error.message}'"
    end

    def find_or_create_event_type(event_class, payload)
      EventsProcessor.const_get("#{event_class}Builder").build(payload)
    end

    def handle_action(event_class, payload, entity)
      ActionHandlers.const_get(event_class).call(payload: payload,
                                                 entity: entity)
    end

    def handleable_event?(event_name)
      Event::TYPES.include?(event_name)
    end

    def find_or_create_user(user_data)
      User.find_or_create_by!(github_id: user_data['id']) do |user|
        user.node_id = user_data['node_id']
        user.login = user_data['login']
      end
    end

    def find_pull_request(payload)
      Events::PullRequest.find_by!(github_id: payload['pull_request']['id'])
    end

    def find_or_create_review_request(pull_request, reviewer_id)
      review_requests = pull_request.review_requests.where(reviewer_id: reviewer_id)
      if review_requests.empty?
        ReviewRequest.create!(owner: pull_request.owner,
                              reviewer_id: reviewer_id,
                              pull_request: pull_request)
      else
        review_requests.order(:created_at).first
      end
    end
  end

  class PullRequestBuilder < EventsProcessor
    def self.build(payload)
      pr_data = payload['pull_request']
      Events::PullRequest.find_or_initialize_by(github_id: pr_data['id']).tap do |pr|
        pr.owner = find_or_create_user(pr_data['user'])
        pr.project = Projects::Builder.call(payload['repository'])
        EventBuilders::PullRequest::ATTR_PAYLOAD_MAP.each { |key, value| pr.public_send("#{key}=", pr_data.fetch(value)) }
        pr.save!
      end
    end
  end

  class ReviewBuilder < EventsProcessor
    ATTR_PAYLOAD_MAP = { body: 'body', state: 'state', opened_at: 'submitted_at' }.freeze

    def self.build(payload)
      review_data = payload['review']
      Events::Review.find_or_initialize_by(github_id: review_data['id']).tap do |review|
        assign_attrs(review, review_data, payload)

        EventBuilders::Review::ATTR_PAYLOAD_MAP.each do |key, value|
          review.public_send("#{key}=", review_data.fetch(value))
        end
        review.save!
      end
    end

    def self.assign_attrs(review, review_data, payload)
      review.owner = find_or_create_user(review_data['user'])
      review.pull_request = find_pull_request(payload)
      review.review_request = find_or_create_review_request(review.pull_request, review.owner.id)
      review.owner.projects << review.pull_request.project
    end
  end

  class ReviewCommentBuilder < EventsProcessor
    def self.build(payload)
      comment_data = payload['comment']
      Events::ReviewComment.find_or_initialize_by(github_id: comment_data['id']).tap do |rc|
        rc.owner = find_or_create_user(comment_data['user'])
        rc.pull_request = find_pull_request(payload)
        rc.body = comment_data['body']
        rc.save!
      end
    end
  end
end
