module Users
  class ExternalPullRequestsController < ApplicationController
    layout 'sidebar_metrics'

    def index
      @external_pull_requests = ExternalPullRequest
                                .where(opened_at: from.weeks.ago..Time.zone.now)
                                .group_by { |pull_request| pull_request.owner.login }
    end

    private

    def from
      params[:from].to_i
    end
  end
end
