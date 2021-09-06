module CodeOwners
  class RepositoryHandler < BaseService
    def initialize(repository, code_owners)
      @repository = repository
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
        repository_code_owners << user unless repository_code_owners.include?(user) || user.nil?
      end
    end

    def remove_old_code_owners
      repository_code_owners.delete(User.where.not(login: @code_owners))
    end

    def repository_code_owners
      @repository_code_owners ||= @repository.code_owners
    end
  end
end
