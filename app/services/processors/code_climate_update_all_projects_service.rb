module Processors
  class CodeClimateUpdateAllProjectsService < BaseService
    def call
      projects do |project|
        update_project(project)
      end
    end

    private

    def projects(&block)
      Repository.find_each(&block)
    end

    def update_project(project)
      CodeClimate::UpdateProjectService.call(project)
    end
  end
end
