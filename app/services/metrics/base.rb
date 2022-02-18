module Metrics
  class Base < BaseService
    Metric = Struct.new(:ownable_id, :value_timestamp, :value)

    def initialize(entity_id, interval = nil)
      @entity_id = entity_id
      @interval = interval
    end

    def call
      process
    end

    private

    def week_intervals
      from = metric_interval.first.to_date
      to = metric_interval.last.to_date
      (from..to).group_by { |t| t.strftime("%W/%Y")}
    end

    def metric_interval
      @metric_interval ||= @interval || Time.zone.today.all_day
    end

    def build_interval(week)
      week_last = week.last
      first = week_last.first
      last = week_last.last

      return first.beginning_of_day..first.end_of_day if first == last

      first..last.end_of_day
    end

    def find_user_repository(user_id, repository_id)
      ::UsersRepository.find_by(user_id: user_id, repository_id: repository_id)
    end
  end
end
