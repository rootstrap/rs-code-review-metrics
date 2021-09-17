module AlertsService
  def call
    search_active_alerts
  end

  def search_active_alerts
    Alerts.each do |alert|
      success_rate = alert_metric_entity(alert)
      search_below_rate(alert, success_rate) if alert.active & success_rate
    end
  end

  def alert_metric_entity(alert)
    entity_is_repo = alert.repository.present?

    return unless entity_is_repo || alert.department.present?

    entity_name = entity_is_repo ? alert.repository.name : alert.department.name

    build_success_rates(alert.metric_name, entity_name)
  end

  def build_success_rates(metric_name, entity_name)
    # search and return success rate for the metric and entity
  end

  def search_below_rate(alert, success_rate)
    return unless alert.threshold < success_rate

    send_alerts_below(alert)
  end

  def send_alerts_below(alert)
    AdminMailer.notify_below_rate(alert).deliver_now
  end
end
