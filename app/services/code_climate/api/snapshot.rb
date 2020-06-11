module CodeClimate
  module Api
    class Snapshot < CodeClimate::Api::Object
      attr_reader :repo_id

      def initialize(json, repo_id)
        super(json)
        @repo_id = repo_id
      end

      def summary
        return unless issues

        ProjectSummary.new(rate: ratings.first,
                           invalid_issues_count: invalid_issues_count,
                           wont_fix_issues_count: wont_fix_issues_count)
      end

      private

      def id
        @json['id']
      end

      def ratings
        ratings_json = @json.dig('attributes', 'ratings')
        ratings_json ? ratings_json.map { |json| json['letter'] } : []
      end

      def issues
        @issues || api_client.snapshot_issues(repo_id: repo_id, snapshot_id: id)
      end

      def invalid_issues_count
        issues.count(&:invalid?)
      end

      def wont_fix_issues_count
        issues.count(&:wontfix?)
      end
    end
  end
end
