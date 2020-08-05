module CodeClimate
  class DepartmentsController < ApplicationController
    layout 'sidebar_metrics'

    def show
      @code_climate = code_climate_department_summary
    end

    private

    def code_climate_department_summary
      CodeClimate::ProjectsDetailsService.call(
        department: department,
        from: department_params[:period],
        technologies: department_params[:lang]
      )
    end

    def department
      @department ||= Department.find_by(name: params[:department_name])
    end

    def department_params
      params.require(:metric).permit(:period, lang: [])
    end
  end
end
