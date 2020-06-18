module CodeOwners
  class ProjectsController < ApplicationController
    def index
      @user = code_owner.user
      @projects = @user.projects
    end

    private

    def code_owner_params
      params.require(:code_owner).permit(:user_id)
    end

    def code_owner
      @code_owner ||= CodeOwnerProject.find_by_user_id(code_owner_params[:user_id])
    end
  end
end
