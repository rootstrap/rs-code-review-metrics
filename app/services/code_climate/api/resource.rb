module CodeClimate
  module Api
    class Resource
      def initialize(api_json)
        @json = api_json
      end

      def api_client
        Client.new
      end
    end
  end
end
