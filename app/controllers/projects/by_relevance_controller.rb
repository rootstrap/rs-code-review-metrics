module Projects
  class ByRelevanceController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def index
      @projects = Builders::Departments::Projects::ByRelevance.call(
        department: department,
        from: metric_params[:period].to_i.weeks.ago
      )
    end

    private

    def department
      @department ||= Department.find_by(name: params[:department_name])
    end

    def metric_params
      params.require(:metric).permit(:period)
    end
  end
end
