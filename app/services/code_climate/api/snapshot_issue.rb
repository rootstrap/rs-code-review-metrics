module CodeClimate
  module Api
    class SnapshotIssue < Resource
      def status
        @status ||= @json.dig('attributes', 'status', 'name')
      end

      def invalid?
        status && status.downcase == 'invalid'
      end

      def open?
        status && %w[new open confirmed].include?(status.downcase)
      end

      def wontfix?
        status && status.downcase == 'wontfix'
      end
    end
  end
end
