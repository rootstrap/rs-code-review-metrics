class AlertsService
  def initialize; end

  def call
    search_active_alerts
  end

  private

  def search_active_alerts
    Alert.find_each do |alert|
      last_sent_date = alert.last_sent_date

      next unless last_sent_date.nil? ||
                  Time.zone.today > alert.frequency.days.from_now(last_sent_date)

      success_rate = alert_metric_entity(alert)

      search_below_rate(alert, success_rate) if alert.active & success_rate
    end
  end

  def alert_metric_entity(alert)
    repository = alert.repository
    department = alert.department

    entity_is_repo = repository.present?

    return unless entity_is_repo || department.present?

    entity_name = entity_is_repo ? Repository.name : Department.name
    entity_id = entity_is_repo ? repository.id : department.id

    build_success_rates(alert.metric_name, entity_id, entity_name)
  end

  def build_success_rates(metric_name, entity_id, entity_name)
    distribution_data = Builders::Chartkick.const_get(parse_entity(entity_name))
                                           .call(entity_id, query(metric_name))

    data = distribution_data.first

    success_rate = data[:success_rate] if data.present?

    success_rate[:rate] if success_rate
  end

  def search_below_rate(alert, success_rate)
    return unless alert.threshold > success_rate

    send_alerts_below(alert)
  end

  def send_alerts_below(alert)
    AdminMailer.notify_below_rate(alert).deliver_now

    alert.update!(last_sent_date: Time.zone.today)
  end

  def parse_entity(entity_name)
    "#{entity_name.classify}DistributionData"
  end

  def query(metric_name)
    {
      name: metric_name,
      value_timestamp: value_timestamp,
      interval: Metrics::Group::Weekly::INTERVAL
    }
  end

  def value_timestamp
    4.weeks.ago.beginning_of_week..current_time.end_of_week
  end

  def current_time
    @current_time ||= Time.zone.now
  end
end
