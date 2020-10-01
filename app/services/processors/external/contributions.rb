module Processors
  module External
    class Contributions < BaseService
      def call
        usernames.each do |username|
          Processors::External::PullRequests.call(username)
        end
      end

      private

      def usernames
        @usernames ||= User.pluck(:login)
      end
    end
  end
end
