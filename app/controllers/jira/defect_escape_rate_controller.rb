module Jira
  class DefectEscapeRateController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def index
      @bugs ||= Builders::Jira::DefectEscapeRate.call(
        jira_project_name: defect_escape_rate_params[:project_name],
        from: defect_escape_rate_params[:from].to_s,
        to: defect_escape_rate_params[:to].to_s
      )
      @total_bugs = @bugs.values.flatten.count
      @user_environments_bugs = @bugs['production'].count + @bugs['staging'].count
      @escape_defect_rate = "#{@user_environments_bugs * 100 / @total_bugs}%"

      render json: {}, status: :ok
    end

    private

    def defect_escape_rate_params
      params.permit(:project_name, :from, :to)
    end
  end
end
