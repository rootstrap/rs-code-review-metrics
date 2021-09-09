module Builders
  module Events
    class Push < Builders::Events::Base
      private

      def build
        ::Events::Push.create! do |push|
          push.ref = @payload['ref']
          push.sender = find_or_create_user(@payload['sender'])
          push.repository = repository
          find_or_create_user_repository(push.repository.id, push.sender.id)
          push.pull_request = pull_request
        end
      end

      def pull_request
        return if tag_ref?

        ::Events::PullRequest.find_by(
          repository: repository,
          branch: ref_name,
          state: ::Events::PullRequest.states[:open]
        )
      end

      def repository
        @repository ||= Builders::Repository.call(@payload['repository'])
      end

      def tag_ref?
        ref_type == 'tags'
      end

      def ref_type
        parsed_ref.second
      end

      def ref_name
        parsed_ref.third
      end

      def parsed_ref
        @parsed_ref ||= @payload['ref'].split('/', 3)
      end
    end
  end
end
