module Builders
  module Chartkick
    class LanguageData < Builders::Chartkick::Base
      def call
        metrics.group_by(&:ownable_id).map do |language_metrics|
          language = Language.find(language_metrics.first)
          { name: language.name, data: build_data(language_metrics.second) }
        end
      end

      private

      def metrics
        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerDepartment
                  .call(@query[:value_timestamp])
        metrics.select { |metric| department_languages_ids.include?(metric.ownable_id) }
      end

      def department_languages_ids
        Department.find(@entity_id).languages.pluck(:id)
      end
    end
  end
end
