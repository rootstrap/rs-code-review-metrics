module CodeClimate
  module Api
    class RemoteQuery
      attr_reader :url, :data

      def initialize(url, data = nil)
        @url = url
        @data = data
      end
    end
  end
end
