module Processors
  class CodeClimateUpdateAllRepositoriesService < BaseService
    def call
      repositories do |repository|
        update_repository(repository)
      end
    end

    private

    def repositories(&block)
      Repository.find_each(&block)
    end

    def update_repository(repository)
      CodeClimate::UpdateRepositoryService.call(repository)
    end
  end
end
