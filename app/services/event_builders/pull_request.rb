module EventBuilders
  class PullRequest < EventBuilder
    ATTR_PAYLOAD_MAP = { github_id: 'id', number: 'number', state: 'state', node_id: 'node_id',
                         title: 'title', locked: 'locked', draft: 'draft' }.freeze
    def build
      pr_data = @payload['pull_request']

      Events::PullRequest.find_or_create_by!(github_id: pr_data['id']) do |pr|
        pr.attributes = ATTR_PAYLOAD_MAP.inject({}) do |hash, (key, _v)|
          hash.merge!(key => pr_data.fetch(ATTR_PAYLOAD_MAP.fetch(key)))
        end
      end
    end
  end
end
