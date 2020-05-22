# The intention of this script is to reprocess all the events stored in Events table all over again.
# This script should be used whenever there are changes in the event types models.

class EventsProcessor
  class << self
    def process(entity)
      errors = []

      retrieve_entity_records(entity) do |event|
        payload = event.data
        event_name = resolve_event_name(event.name)
        Projects::Builder.call(payload['repository'])
        process_event(event, event_name)
      rescue StandardError => e
        error = error_msg(event, e)
        errors << error unless error.nil?
      end
      Rails.logger.error errors unless errors.empty?
    end

    def retrieve_entity_records(types)
      types = Event::TYPES if types == 'all'
      Event.where('data ?| array[:keys]', keys: types).find_each.lazy.each do |event|
        yield(event)
      end
    end

    def resolve_event_name(name)
      return name.gsub('pull_request_', '') unless name == 'pull_request'

      name
    end

    def process_event(event, event_name)
      payload = event.data
      event_class = event_name.classify

      entity = find_or_create_event_type(event_class, payload)
      handle_action(event_class, payload, entity)
    end

    def error_msg(event, error)
      return if rescued_errors.include?(error.class)

      "#{event.name.humanize} with ID: '#{event.id}', failed with '#{error.message}'"
    end

    def rescued_errors
      [Events::NotHandleableError,
       Reviews::NoReviewRequestError,
       PullRequests::RequestTeamAsReviewerError]
    end

    def find_or_create_event_type(event_class, payload)
      EventsProcessor.const_get("#{event_class}Builder").build(payload)
    end

    def handle_action(event_class, payload, entity)
      ActionHandlers.const_get(event_class).call(payload: payload,
                                                 entity: entity)
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

    def find_last_review_request(pull_request, reviewer_id)
      review_request = pull_request.review_requests.where(reviewer_id: reviewer_id).last
      return review_request unless review_request.nil?

      raise Reviews::NoReviewRequestError
    end

    def find_or_create_user_project(project_id, user_id)
      UsersProject.find_or_create_by!(project_id: project_id, user_id: user_id)
    end
  end

  class PullRequestBuilder < EventsProcessor
    def self.build(payload)
      pr_data = payload['pull_request']
      Events::PullRequest.find_or_initialize_by(github_id: pr_data['id']).tap do |pr|
        pr.owner = find_or_create_user(pr_data['user'])
        pr.project = Projects::Builder.call(payload['repository'])
        EventBuilders::PullRequest::ATTR_PAYLOAD_MAP.each do |key, value|
          pr.public_send("#{key}=", pr_data.fetch(value))
        end
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
        assign_user_project(review, payload)

        EventBuilders::Review::ATTR_PAYLOAD_MAP.each do |key, value|
          review.public_send("#{key}=", review_data.fetch(value))
        end
        review.save!
      end
    end

    def self.assign_attrs(review, review_data, payload)
      review.pull_request = find_pull_request(payload)
      review.owner = find_or_create_user(review_data['user'])
      review.review_request = find_last_review_request(review.pull_request, review.owner_id)
    end

    def self.assign_user_project(review, payload)
      review.project = Projects::Builder.call(payload['repository'])
      find_or_create_user_project(review.project_id, review.owner_id)
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
