module Processors
  module External
    class Contributions < BaseService
      def call
        usernames.each do |username|
          repositories_data = Processors::External::Repositories.call(username)
          repositories_data.each do |repository_data|
            Processors::External::PullRequests.call(repository_data, username)
          end
        end
      end

      private

      def usernames
        @usernames ||= User.pluck(:login)
      end
    end
  end
end
