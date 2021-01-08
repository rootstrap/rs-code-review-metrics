module Processors
  class CodeClimateUpdater < BaseService
    def call
      Project.find_each do |project|
        CodeClimate::Link.call(project)
      end
    end
  end
end
