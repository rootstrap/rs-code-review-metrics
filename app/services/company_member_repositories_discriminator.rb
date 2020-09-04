class CompanyMemberRepositoriesDiscriminator < BaseService
  def initialize(repositories)
    @repositories = repositories
  end

  def call
    @repositories.reject { |repository| company_members.include? repository[:owner][:login] }
  end

  private

  def company_members
    User.pluck(:login)
  end
end
