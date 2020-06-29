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
      CodeClimate::ProjectsSummaryService.call(
        department: department,
        from: nil,
        technologies: []
      )
    end

    def department
      @department ||= Department.find(params[:id])
    end
  end
end
