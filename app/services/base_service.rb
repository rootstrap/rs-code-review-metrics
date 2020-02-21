# frozen_string_literal: true

# Base class for service classes
class BaseService
  private_class_method :new

  def self.call(*args)
    new(*args).call
  end

  private

  def find_or_create_user(user_data)
    User.find_or_create_by!(github_id: user_data['id']) do |user|
      user.node_id = user_data['node_id']
      user.login = user_data['login']
    end
  end
end
