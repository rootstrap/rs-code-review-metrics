class ApplicationController < ActionController::Base
  before_action { Rack::MiniProfiler.authorize_request if current_admin_user.present? }

  def not_found
    render file: 'public/404.html', status: :not_found
  end
end
