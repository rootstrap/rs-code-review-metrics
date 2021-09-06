module Processors
  class ProjectPrivacyBackfiller < BaseService
    def call
      Repository.find_each do |repository|
        repository.update(is_private: repository.events.first&.data&.dig('repository', 'private'))
      end
    end
  end
end
