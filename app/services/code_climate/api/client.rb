module CodeClimate
  module Api
    class Client
      CODE_CLIMATE_API_TOKEN = ENV['CODE_CLIMATE_API_TOKEN']
      CODE_CLIMATE_API_URL = ENV['CODE_CLIMATE_API_URL']
      CODE_CLIMATE_API_HEADERS = {
        'Accept': 'application/vnd.api+json',
        'Authorization': "Token token=#{CODE_CLIMATE_API_TOKEN}"
      }.freeze

      def repository_by_slug(github_slug:)
        json = get_json(repository_by_slug_remote_query(github_slug: github_slug))
        # Despite of the name this endpoint returns a collection of repositories
        repository_data = json['data'].first

        return if repository_data.blank?

        Repository.new(repository_data)
      end

      def snapshot(repo_id:, snapshot_id:)
        json = get_json(snapshot_remote_query(repo_id: repo_id, snapshot_id: snapshot_id))
        Snapshot.new(json['data'], repo_id)
      end

      def snapshot_issues(repo_id:, snapshot_id:)
        json = get_json(snapshot_issues_remote_query(repo_id: repo_id, snapshot_id: snapshot_id))
        json['data'].map { |issue_json| SnapshotIssue.new(issue_json) }
      end

      private

      def repository_by_id_remote_query(repository_id:)
        RemoteQuery.new("repos/#{repository_id}")
      end

      def repository_by_slug_remote_query(github_slug:)
        RemoteQuery.new('repos', github_slug: github_slug)
      end

      def snapshot_remote_query(repo_id:, snapshot_id:)
        RemoteQuery.new("repos/#{repo_id}/snapshots/#{snapshot_id}")
      end

      def snapshot_issues_remote_query(repo_id:, snapshot_id:)
        RemoteQuery.new("repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
      end

      def get_json(remote_query)
        body = get_body(remote_query)
        JSON.parse(body)
      end

      def get_body(remote_query)
        response = do_get(remote_query)
        response.body
      end

      def do_get(remote_query)
        http_client.get(remote_query.url, remote_query.data)
      end

      def http_client
        Faraday.new(
          url: CODE_CLIMATE_API_URL,
          headers: CODE_CLIMATE_API_HEADERS
        ) do |connection|
          connection.response(:raise_error)
        end
      end
    end
  end
end
