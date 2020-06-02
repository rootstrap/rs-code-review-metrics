module Builders
  module Events
    class PullRequest < EventBuilder
      ATTR_PAYLOAD_MAP = { number: 'number', state: 'state', node_id: 'node_id',
                           title: 'title', locked: 'locked', draft: 'draft',
                           opened_at: 'created_at' }.freeze

      def build
        pull_request_data = @payload['pull_request']
        ::Events::PullRequest
          .find_or_create_by!(github_id: pull_request_data['id']) do |pull_request|
          assign_attrs(pull_request, pull_request_data)

          ATTR_PAYLOAD_MAP.each do |key, value|
            pull_request.public_send("#{key}=", pull_request_data.fetch(value))
          end
        end
      end

      def assign_attrs(pull_request, pull_request_data)
        pull_request.owner = find_or_create_user(pull_request_data['user'])
        pull_request.project = Builders::Project.call(@payload['repository'])
        find_or_create_user_project(pull_request.project.id, pull_request.owner.id)
      end
    end
  end
end
