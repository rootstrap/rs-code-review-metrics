class DepartmentsController < ApplicationController
  def show
    @department = Department.first
  end
end
