module Builders
  module Chartkick
    class LanguagesDepartmentData < Builders::Chartkick::Base
      def call
        retrieve_projects_by_lang.map do |project|
          metrics = project.metrics.where(@query)
          { name: project.language.name, data: build_data(metrics) }
        end
      end

      private

      def retrieve_projects_by_lang
        department = Department.find(@entity_id)
        languages_names = Language.pluck(:name)
        ::Project.joins(:language)
                 .where("languages.name::text = ANY('{#{languages_names.join(',')}}')")
      end
    end
  end
end
