module CodeClimate
  class UpdateAllProjectsService < BaseService
    def call
      projects do |project|
        update_project(project)
      end
    end

    private

    def projects(&block)
      Project.find_each(&block)
    end

    def update_project(project)
      UpdateProjectService.call(project)
    end
  end
end
