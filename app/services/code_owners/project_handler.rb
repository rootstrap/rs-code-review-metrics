module CodeOwners
  class ProjectHandler < BaseService
    def initialize(project, code_owners)
      @project = project
      @code_owners = code_owners
    end

    def call
      remove_old_code_owners
      add_new_code_owners
    end

    private

    def add_new_code_owners
      @code_owners.each do |code_owner_name|
        user = User.find_by(login: code_owner_name)
        next if user.nil?

        project_code_owners << user unless project_code_owners.include?(user)
      end
    end

    def remove_old_code_owners
      project_code_owners.delete(User.where.not(login: @code_owners))
    end

    def project_code_owners
      @project_code_owners ||= @project.code_owners
    end
  end
end
