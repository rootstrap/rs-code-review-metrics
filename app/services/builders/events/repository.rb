module Builders
  module Events
    class Repository < Builders::Events::Base
      private

      def build
        ::Events::Repository.create! do |repo|
          repo.action = @payload['action']
          repo.html_url = @payload['html_url']
          repo.sender = find_or_create_user(@payload['sender'])
          repo.repository = repository
          find_or_create_user_repository(repo.repository.id, repo.sender.id)
        end
      end

      def repository
        @repository ||= Builders::Project.call(@payload['repository'])
      end
    end
  end
end
