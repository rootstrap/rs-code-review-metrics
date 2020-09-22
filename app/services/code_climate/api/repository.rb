module CodeClimate
  module Api
    class Repository < Resource
      delegate :ratings, :issues_collection, :snapshot_time,
               to: :default_branch_most_recent_snapshot
      delegate :coverage,
               to: :default_branch_most_recent_test_report

      def summary
        ProjectSummary.new(
          rate: ratings.first,
          issues: issues_collection,
          snapshot_time: snapshot_time,
          test_coverage: coverage,
          repository_id: repository_id
        )
      end

      private

      def repository_id
        @repository_id ||= @json['id']
      end

      def default_branch_most_recent_snapshot
        @default_branch_most_recent_snapshot ||=
          if snapshot_id.blank?
            MissingResource.new
          else
            api_client.snapshot(repo_id: repository_id, snapshot_id: snapshot_id)
          end
      end

      def default_branch_most_recent_test_report
        @default_branch_most_recent_test_report ||=
          if test_report_id.blank?
            MissingResource.new
          else
            api_client.test_report(repo_id: repository_id, test_report_id: test_report_id)
          end
      end

      def snapshot_id
        @json.dig('relationships', 'latest_default_branch_snapshot', 'data', 'id')
      end

      def test_report_id
        @json.dig('relationships', 'latest_default_branch_test_report', 'data', 'id')
      end
    end
  end
end
