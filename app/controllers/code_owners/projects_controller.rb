module CodeOwners
  class ProjectsController < ApplicationController
    def index
      @projects = user.projects_as_code_owner
    end

    private

    def code_owner_params
      params.require(:code_owner).permit(:user_id)
    end

    def user
      @user ||= User.find_by(id: code_owner_params[:user_id])
    end
  end
end
