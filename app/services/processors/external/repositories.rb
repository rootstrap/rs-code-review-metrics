module Processors
  module External
    class Repositories < BaseService
      def initialize(username)
        @username = username
      end

      def call
        RootstrapMemberRepositoriesDiscriminator.call(repositories)
      end

      private

      def repositories
        @repositories ||= GithubClient::User.new(@username).repositories
      end
    end
  end
end
