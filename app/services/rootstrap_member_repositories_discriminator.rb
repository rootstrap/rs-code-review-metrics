class RootstrapMemberRepositoriesDiscriminator < BaseService
  def initialize(repositories)
    @repositories = repositories
  end

  def call
    @repositories.reject { |repository| rs_members.include? repository[:owner][:login] }
  end

  private

  def rs_members
    User.pluck(:login)
  end
end
