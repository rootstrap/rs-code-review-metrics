class AdminSendAlertsJob < ApplicationJob
  queue_as :default

  def perform
    AlertsService.call
  end
end
