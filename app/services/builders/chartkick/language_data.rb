module Builders
  module Chartkick
    class LanguageData < Builders::Chartkick::Base
      def call
        retrieve_department_languages_metrics.map do |language|
          metrics = language.metrics.where(@query)
          { name: language.name, data: build_data(metrics) }
        end
      end

      private

      def retrieve_department_languages_metrics
        Department.find(@entity_id).languages
      end
    end
  end
end
