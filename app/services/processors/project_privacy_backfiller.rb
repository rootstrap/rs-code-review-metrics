module Processors
  class ProjectPrivacyBackfiller < BaseService
    def call
      Project.find_each do |project|
        project.update(private: project.events.first&.data&.dig('repository', 'private'))
      end
    end
  end
end
