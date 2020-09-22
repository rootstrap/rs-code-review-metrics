module CodeClimate
  module Api
    class MissingResource
      def ratings
        []
      end

      def issues_collection
        {}
      end

      def snapshot_time
        nil
      end

      def coverage
        nil
      end
    end
  end
end
