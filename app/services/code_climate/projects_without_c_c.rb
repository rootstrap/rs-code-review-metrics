module CodeClimate
  class ProjectsWithoutCC < BaseService
    attr_reader :department, :from, :languages

    def initialize(department:, from:, languages:)
      @department = department
      @from = from.to_i
      @languages = languages
    end

    def call
      projects_in_given_languages
        .without_cc_or_cc_rate
        .distinct
        .relevant
        .order('projects.name')
    end

    private

    def projects_in_given_languages
      if languages.present?
        projects_in_time_period.by_language(languages)
      else
        projects_in_time_period
      end
    end

    def projects_in_time_period
      if from.positive?
        projects_in_department.with_activity_after(from.weeks.ago)
      else
        projects_in_department
      end
    end

    def projects_in_department
      Project.by_department(department)
    end
  end
end
