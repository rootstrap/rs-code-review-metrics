module Builders
  module Departments
    module Projects
      class ByRelevance < BaseService
        include ModelsNamesHelper

        def initialize(department:, from:)
          @department = department
          @from = from
        end

        def call
          language_names.each_with_object({}) { |language, overview|
            overview[language] = language_overview(language)
          }.with_indifferent_access
        end

        private

        attr_reader :department, :from

        def language_names
          all_languages_names(department)
        end

        def language_overview(language)
          relevances_overview(language)
        end

        def relevances_overview(language)
          repository_relevances.index_with do |relevance|
            ::Repository.joins(:language)
                        .relevant.with_activity_after(from)
                        .where(relevance: relevance)
                        .where('languages.name = ?', language)
                        .distinct
          end
        end

        def repository_relevances
          relevances = ::Repository.relevances
          [
            relevances[:internal],
            relevances[:commercial]
          ]
        end
      end
    end
  end
end
