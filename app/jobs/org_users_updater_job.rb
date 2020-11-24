class OrgUsersUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::OrgUsersUpdater.call
  end
end
