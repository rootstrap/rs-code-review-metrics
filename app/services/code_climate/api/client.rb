module CodeClimate
  module Api
    class Client
      CODE_CLIMATE_API_TOKEN = ENV['CODE_CLIMATE_API_TOKEN']
      CODE_CLIMATE_API_URL = ENV['CODE_CLIMATE_API_URL']
      CODE_CLIMATE_API_HEADERS = {
        'Accept': 'application/vnd.api+json',
        'Authorization': "Token token=#{CODE_CLIMATE_API_TOKEN}"
      }.freeze

      def repositories(org_id:)
        response_json = get_json(RemoteQuery.new("orgs/#{org_id}/repos"))
        response_json && response_json['data'].map do |repository_json|
          Repository.new(repository_json)
        end
      end

      def repository(repository_id: nil, github_slug: nil)
        json = if github_slug
                 get_json(RemoteQuery.new('repos', github_slug: github_slug))
               else
                 get_json(RemoteQuery.new("repos/#{repository_id}"))
               end
        # Despite of the name this endpoint returns a collection of repositories
        json && Repository.new(json['data'].first)
      end

      def snapshot(repo_id:, snapshot_id:)
        json = get_json(RemoteQuery.new("repos/#{repo_id}/snapshots/#{snapshot_id}"))
        json && Snapshot.new(json['data'], repo_id)
      end

      def snapshot_issues(repo_id:, snapshot_id:)
        json = get_json(RemoteQuery.new("repos/#{repo_id}/snapshots/#{snapshot_id}/issues"))
        json && json['data'].map { |issue_json| SnapshotIssue.new(issue_json) }
      end

      private

      def get_json(remote_query)
        body = get_body(remote_query)
        body && JSON.parse(body)
      end

      def unsafe_get_json(remote_query)
        JSON.parse(get_body(remote_query))
      end

      def get_body(remote_query)
        response = do_get(remote_query)
        response.success? ? response.body : nil
      end

      def do_get(remote_query)
        http_client.get(remote_query.url, remote_query.data)
      end

      def http_client
        Faraday.new(
          url: CODE_CLIMATE_API_URL,
          headers: CODE_CLIMATE_API_HEADERS
        )
      end
    end
  end
end
