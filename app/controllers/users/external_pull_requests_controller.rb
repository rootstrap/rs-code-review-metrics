module Users
  class ExternalPullRequestsController < ApplicationController
    layout 'sidebar_metrics'

    def index
      date = from.weeks.ago
      @external_pull_requests = ExternalPullRequest
                                .joins(:external_project).merge(ExternalProject.enabled)
                                .joins(:owner).merge(User.members_since(date))
                                .where(opened_at: date..Time.zone.now)
                                .group_by { |pull_request| pull_request.owner.login }
    end

    private

    def from
      params[:from].to_i
    end
  end
end
