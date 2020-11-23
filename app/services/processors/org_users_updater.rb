module Processors
  class OrgUsersUpdater < BaseService
    def call
      User.where(login: current_members).find_each { |user| user.update(company_member: true) }
      User.where.not(login: current_members).find_each { |user| user.update(company_member: false) }
    end

    private

    def current_members
      @current_members ||= GithubClient::Organization.new.members
    end
  end
end
