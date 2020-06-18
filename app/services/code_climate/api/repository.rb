module CodeClimate
  module Api
    class Repository < Resource
      def summary
        default_branch_most_recent_snapshot&.summary
      end

      def repository_id
        @json['id']
      end

      private

      def default_branch_most_recent_snapshot
        api_client.snapshot(repo_id: repository_id, snapshot_id: snapshot_id)
      end

      def snapshot_id
        @json.dig('relationships', 'latest_default_branch_snapshot', 'data', 'id')
      end
    end
  end
end
