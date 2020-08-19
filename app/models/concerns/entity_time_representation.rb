module EntityTimeRepresentation
  extend ActiveSupport::Concern

  def value_as_hours
    (value.to_f / 1.hour.seconds).round(2)
  end
end
