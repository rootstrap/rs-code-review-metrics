module CodeClimate
  module Api
    class TestReport < Resource
      def coverage
        @json.dig('attributes', 'covered_percent')
      end
    end
  end
end
