module CodeClimate
  class DepartmentsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def show
      @code_climate = code_climate_department_summary
      @repositories_without_cc = repositories_without_cc
    end

    private

    def code_climate_department_summary
      CodeClimate::RepositoriesDetailsService.call(
        department: department,
        from: department_params[:period],
        technologies: department_params[:lang]
      )
    end

    def repositories_without_cc
      CodeClimate::RepositoriesWithoutCC.call(
        department: department,
        from: department_params[:period],
        languages: department_params[:lang]
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
