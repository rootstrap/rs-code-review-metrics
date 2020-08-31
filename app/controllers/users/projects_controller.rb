module Users
  class ProjectsController < ApplicationController
    layout 'sidebar_metrics'

    def index
      @projects = user.projects_as_code_owner
    end

    private

    def user
      @user ||= User.find(params[:user_id])
    end
  end
end
