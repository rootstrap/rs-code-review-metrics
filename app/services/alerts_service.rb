class AlertsService
  def initialize; end

  def call
    search_active_alerts
  end

  private

  def search_active_alerts
    Alert.find_each do |alert|
      success_rate = alert_metric_entity(alert)

      search_below_rate(alert, success_rate) if alert.active & success_rate
    end
  end

  def alert_metric_entity(alert)
    entity_is_repo = alert.repository.present?

    return unless entity_is_repo || alert.department.present?

    entity_name = entity_is_repo ? Repository.name : Department.name
    entity_id = entity_is_repo ? alert.repository.id : alert.department.id

    build_success_rates(alert.metric_name, entity_id, entity_name)
  end

  def build_success_rates(metric_name, entity_id, entity_name)
    data = Builders::Chartkick::RepositoryDistributionData.call(entity_id, query(metric_name))

    data.first[:success_rate][:rate] if data.first.present? & data.first[:success_rate]
  end

  def search_below_rate(alert, success_rate)
    return unless alert.threshold > success_rate

    send_alerts_below(alert)
  end

  def send_alerts_below(alert)
    AdminMailer.notify_below_rate(alert).deliver_now
  end

  def query(metric_name)
    {
      name: metric_name,
      value_timestamp: value_timestamp,
      interval: Metrics::Group::Weekly::INTERVAL
    }
  end

  def value_timestamp
    (current_time - 4.weeks).beginning_of_week..current_time.end_of_week
  end

  def current_time
    @current_time ||= Time.zone.now
  end
end
