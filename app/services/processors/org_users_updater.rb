module Processors
  class OrgUsersUpdater < BaseService
    def call
      current_time = Time.current
      User.where(login: current_members, company_member_since: nil)
          .update_all(company_member_since: current_time)

      User.where.not(login: current_members)
          .where.not(company_member_since: nil)
          .update_all(company_member_until: current_time)
    end

    private

    def current_members
      @current_members ||= GithubClient::Organization.new.members
    end
  end
end
