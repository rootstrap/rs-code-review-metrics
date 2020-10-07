module Builders
  class DepartmentOverview < BaseService
    include ModelsNamesHelper

    def initialize(department, from:)
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

    def projects_by_language_and_relevance
      @projects_by_language_and_relevance ||=
        ::Project.joins(:language)
                 .relevant.with_activity_after(from)
                 .where(language: department.languages)
                 .distinct
                 .group('languages.name', 'projects.relevance')
                 .count
    end

    def language_overview(language)
      relevances_overview = relevances_overview(language)
      {
        per_relevance: relevances_overview,
        totals: relevances_overview.values.sum
      }
    end

    def relevances_overview(language)
      project_relevances.index_with do |relevance|
        projects_by_language_and_relevance[[language, relevance]] || 0
      end
    end

    def language_names
      all_languages_names(department)
    end

    def project_relevances
      relevances = ::Project.relevances
      [
        relevances[:internal],
        relevances[:commercial]
      ]
    end
  end
end
