module Processors
  class CodeClimateUpdater < BaseService
    def call
      Repository.find_each do |repository|
        CodeClimate::Link.call(repository)
      end
    end
  end
end
