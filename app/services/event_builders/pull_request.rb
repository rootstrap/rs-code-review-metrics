module EventBuilders
  class PullRequest < EventBuilder
    ATTR_PAYLOAD_MAP = { github_id: 'id', number: 'number', state: 'state',
                         node_id: 'node_id', title: 'title', locked: 'locked',
                         draft: 'draft', opened_at: 'created_at' }.freeze

    def build
      pr_data = @payload['pull_request']
      Events::PullRequest.find_or_create_by!(github_id: pr_data['id']) do |pr|
        pr.owner = find_or_create_user(pr_data['user'])
        pr.project = Projects::Builder.call(@payload['repository'])
        ATTR_PAYLOAD_MAP.each { |key, value| pr.public_send("#{key}=", pr_data.fetch(value)) }
      end
    end
  end
end
