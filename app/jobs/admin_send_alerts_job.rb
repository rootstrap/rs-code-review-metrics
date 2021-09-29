class AdminSendAlertsJob < ApplicationJob
  queue_as :default

  def perform
    AlertsService.new.call
  end
end
