class ApplicationController < ActionController::Base
  before_action { Rack::MiniProfiler.authorize_request if current_admin_user.present? }
end
