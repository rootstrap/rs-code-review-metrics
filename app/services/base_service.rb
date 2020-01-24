# frozen_string_literal: true

# Base class for service classes
class BaseService
  private_class_method :new

  def self.call(*args)
    new(*args)
  end
end
