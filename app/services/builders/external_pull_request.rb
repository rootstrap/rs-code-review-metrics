module Builders
  class ExternalPullRequest < BaseService
    def initialize(pull_request_data)
      @pull_request_data = pull_request_data
    end

    def call
      pull_request = ::ExternalPullRequest
                     .find_or_initialize_by(
                       github_id: pull_request_data[:id]
                     ) do |ext_pull_request|
        assign_attributes(ext_pull_request)
      end
      pull_request.state = assign_state
      pull_request.save!
      pull_request
    end

    private

    attr_reader :pull_request_data

    def assign_attributes(pull_request)
      assign_html_url(pull_request)
      assign_body(pull_request)
      assign_title(pull_request)
      assign_opened_at(pull_request)
      assign_number(pull_request)
      assign_owner(pull_request)
      assign_external_repository(pull_request)
    end

    def assign_html_url(pull_request)
      pull_request.html_url = pull_request_data[:html_url]
    end

    def assign_body(pull_request)
      pull_request.body = pull_request_data[:body]
    end

    def assign_title(pull_request)
      pull_request.title = pull_request_data[:title]
    end

    def assign_opened_at(pull_request)
      pull_request.opened_at = pull_request_data[:created_at]
    end

    def assign_number(pull_request)
      pull_request.number = pull_request_data[:number]
    end

    def assign_owner(pull_request)
      pull_request.owner = owner
    end

    def assign_external_repository(pull_request)
      pull_request.external_repository = external_repository
    end

    def assign_state
      return 'merged' if pull_request_data[:merged]

      pull_request_data[:state]
    end

    def external_repository
      Builders::ExternalRepository.call(pull_request_data.dig(:base, :repo))
    end

    def owner
      find_or_create_user(pull_request_data[:user].with_indifferent_access)
    end

    class FromUrlParams < BaseService
      def initialize(repository_full_name, pull_request_number)
        @repository_full_name = repository_full_name
        @pull_request_number = pull_request_number
      end

      def call
        Builders::ExternalPullRequest.call(pull_request_data) if pull_request_data.present?
      end

      private

      def pull_request_data
        GithubClient::PullRequest.new(pull_request).get
      rescue Faraday::ResourceNotFound => exception
        Rails.logger.error("Failed to fetch pull request data: #{exception.message}")

        Honeybadger.notify(exception, context: {
                             repository_full_name: @repository_full_name,
                             pull_request_number: @pull_request_number
                           })

        nil
      end

      def pull_request
        repository = ::ExternalRepository.new(full_name: @repository_full_name)
        ::ExternalPullRequest.new(number: @pull_request_number, external_repository: repository)
      end
    end
  end
end
