module PullRequests
  class TimeToSecondReviewPrsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def index
      @pull_requests_department = Builders::Distribution::PullRequests::TimeToSecondReview.call(
        department_name: params[:department_name],
        from: metric_params[:period],
        languages: metric_params[:lang] || []
      )
    end

    def metric_params
      params.require(:metric).permit(:period, lang: [])
    end
  end
end
