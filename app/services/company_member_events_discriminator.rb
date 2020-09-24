class CompanyMemberEventsDiscriminator < BaseService
  def initialize(events)
    @events = events
  end

  def call
    @events.reject { |event| company_members.include? event[:repo][:name].split('/').first }
  end

  private

  def company_members
    User.pluck(:login) << ENV.fetch('GITHUB_ORGANIZATION', 'rootstrap')
  end
end
