module RepositoryValidator
  def verify_repository_existence
    repository = Repository.find_by!(name: params[:repository_name])
    @repository_name = repository.name
  rescue ActiveRecord::RecordNotFound => exception
    flash.now[:alert] = exception.message
  end
end
