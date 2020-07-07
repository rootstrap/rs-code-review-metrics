module CodeClimate
  class DepartmentsController < ApplicationController
    def show
      @code_climate = code_climate_department_summary
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    private

    # this needs to be implemented and tested
    def code_climate_department_summary
      CodeClimate::ProjectsDetailsService.call(
        department: department,
        from: nil,
        technologies: []
      )
    end

    def department
      @department ||= Department.find_by_name(params[:department_name])
    end
  end
end
