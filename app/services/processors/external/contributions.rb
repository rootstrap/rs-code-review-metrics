module Processors
  module External
    class Contributions < BaseService
      def call
        usernames.each do |username|
          repositories_data = Processors::External::Repositories.call(username)
          repositories_data.each do |repository_data|
            project = Builders::ExternalProject.call(repository_data)
            Processors::External::PullRequests.call(project, username)
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
