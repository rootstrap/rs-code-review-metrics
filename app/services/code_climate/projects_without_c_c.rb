module CodeClimate
  class ProjectsWithoutCC < BaseService
    attr_reader :department, :from, :languages

    def initialize(department:, from:, languages:)
      @department = department
      @from = from.to_i
      @languages = languages
    end

    def call
      projects_in_given_languages(projects_in_department)
        .where.not(id: projects_with_cc_ids)
        .order('LOWER(projects.name)')
    end

    private

    def projects_with_cc_ids
      projects_in_given_languages(projects_in_time_period).distinct.pluck(:id)
    end

    def projects_in_given_languages(scope)
      if languages.present?
        scope.by_language(languages)
      else
        scope
      end
    end

    def projects_in_time_period
      if from.positive?
        projects_in_department.by_metrics_time(from)
      else
        projects_in_department
      end
    end

    def projects_in_department
      Project.by_department(department)
    end
  end
end
