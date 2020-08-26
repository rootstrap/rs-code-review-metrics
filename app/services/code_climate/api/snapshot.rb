module CodeClimate
  module Api
    class Snapshot < Resource
      def initialize(json, repo_id)
        super(json)
        @repo_id = repo_id
      end

      def ratings
        ratings_json = @json.dig('attributes', 'ratings')
        ratings_json ? ratings_json.map { |json| json['letter'] } : []
      end

      def snapshot_time
        DateTime.parse(@json.dig('attributes', 'committed_at'))
      end

      def issues_collection
        {
          invalid_issues_count: invalid_issues_count,
          open_issues_count: open_issues_count,
          wont_fix_issues_count: wont_fix_issues_count
        }
      end

      private

      attr_reader :repo_id

      def snapshot_id
        @json['id']
      end

      def issues
        @issues ||= api_client.snapshot_issues(repo_id: repo_id, snapshot_id: snapshot_id)
      end

      def invalid_issues_count
        issues.count(&:invalid?)
      end

      def open_issues_count
        issues.count(&:open?)
      end

      def wont_fix_issues_count
        issues.count(&:wontfix?)
      end
    end
  end
end
