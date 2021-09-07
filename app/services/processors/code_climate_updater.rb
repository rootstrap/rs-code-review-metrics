module Processors
  class CodeClimateUpdater < BaseService
    def call
      Repository.find_each do |project|
        CodeClimate::Link.call(project)
      end
    end
  end
end
