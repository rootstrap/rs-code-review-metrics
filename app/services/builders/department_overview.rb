module Builders
  class DepartmentOverview < BaseService
    include ModelsNamesHelper

    def initialize(department)
      @department = department
    end

    def call
      department_overview = language_names.each_with_object({}) do |language, overview|
        overview[language] = language_overview(language)
      end

      department_overview.with_indifferent_access
    end

    private

    attr_reader :department

    def projects_by_language_and_relevance
      @projects_by_language_and_relevance ||=
        department
        .languages
        .joins(:projects)
        .merge(::Project.relevant)
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
      project_relevances.each_with_object({}) do |relevance, overview|
        overview[relevance] = projects_by_language_and_relevance[[language, relevance]] || 0
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
