module Builders
  module Chartkick
    class GenerateChartImage
      QUICKCHART_URL = 'https://quickchart.io/chart/create'.freeze

      def initialize(label_name, data, suffix, type)
        @label_name = label_name
        @data = data
        @suffix = suffix
        @type = type
      end

      def generate_url
        response = Faraday.post(QUICKCHART_URL,
                                request_body.to_json,
                                'Content-Type': 'application/json')

        response_body = JSON.parse(response.body)

        return unless response.status == 200 && response_body['success']

        response_body['url']
      rescue Faraday::ServerError => exception
        ExceptionHunter.track(exception)
      end

      def generate_url_mutiple_bar
        response = Faraday.post(QUICKCHART_URL,
                                request_body_multiple.to_json,
                                'Content-Type': 'application/json')

        response_body = JSON.parse(response.body)

        return unless response.status == 200 && response_body['success']

        response_body['url']
      rescue Faraday::ServerError => exception
        ExceptionHunter.track(exception)
      end

      private

      def request_body
        {
          "backgroundColor": '#fff',
          "width": 500,
          "height": 300,
          "devicePixelRatio": 1.0,
          "chart": {
            "type": @type,
            "options": {
              "plugins": {
                "tickFormat": {
                  "suffix": @suffix
                }
              }
            },
            "data": single_data
          }
        }
      end

      def request_body_multiple
        {
          "backgroundColor": '#fff',
          "width": 500,
          "height": 300,
          "chart": {
            "type": @type,
            "options": {
              "plugins": {
                "tickFormat": {
                  "suffix": @suffix
                }
              }
            },
            "data": multiple_data
          }
        }
      end

      def single_data
        {
          "labels": @data.keys,
          "datasets": [
            {
              "label": @label_name,
              "fill": false,
              "lineTension": 0.4,
              "data": @data.values
            }
          ]
        }
      end

      def multiple_data
        first_chart = @data.first
        first_chart_data = first_chart[:data]
        second_chart = @data.second

        {
          "labels": first_chart_data.keys,
          "datasets": [
            {
              "label": first_chart[:name],
              "data": first_chart_data.values
            },
            {
              "label": second_chart[:name],
              "data": second_chart[:data].values
            }
          ]
        }
      end
    end
  end
end
