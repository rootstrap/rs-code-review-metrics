module CodeClimate
  class ProjectsWithoutCC < BaseService
    attr_reader :department, :from, :languages

    def initialize(department:, from:, languages:)
      @department = department
      @from = from.to_i
      @languages = languages
    end

    def call
      repository_in_given_languages
        .without_cc_or_cc_rate
        .distinct
        .relevant
        .order('repositories.name')
    end

    private

    def repository_in_given_languages
      if languages.present?
        repository_in_time_period.by_language(languages)
      else
        repository_in_time_period
      end
    end

    def repository_in_time_period
      if from.positive?
        repository_in_department.with_activity_after(from.weeks.ago)
      else
        repository_in_department
      end
    end

    def repository_in_department
      Repository.by_department(department)
    end
  end
end
