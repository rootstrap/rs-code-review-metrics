module CodeClimate
  module Api
    class Repository < CodeClimate::Api::Object
      def summary
        default_branch_most_recent_snapshot.summary.tap do |hash|
          hash[id] = id
        end
      end

      private

      def id
        @json['id']
      end

      def default_branch_most_recent_snapshot
        api_client.snapshot(repo_id: id, snapshot_id: snapshot_id)
      end

      def snapshot_id
        @json.dig('relationships', 'latest_default_branch_snapshot', 'data', 'id')
      end
    end
  end
end
