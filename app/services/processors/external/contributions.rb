module Processors
  module External
    class Contributions < BaseService
      def call
        usernames.each do |username|
          ExternalPullRequestsProcessorJob.perform_later(username)
        end
      end

      private

      def usernames
        @usernames ||= User.pluck(:login)
      end
    end
  end
end
