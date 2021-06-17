module Builders
  module Chartkick
    class DefectEscapeValueData < Builders::Chartkick::ProjectData
      def build_data(metrics)
        values = metrics.inject({}) do |hash, metric|
          hash.merge!(metric.value[:bugs_by_environment]) { |_key, old, new| new + old }
        end
        total = values.values.inject(:+)
        rate = (values['production'].to_i + values['staging'].to_i) * 100 / total if total
        { values: values, total: total, rate: rate }
      end
    end
  end
end
