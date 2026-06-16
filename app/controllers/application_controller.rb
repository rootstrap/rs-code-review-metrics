class ApplicationController < ActionController::Base
  before_action :authenticate_admin_user!, unless: :devise_controller?
  before_action { Rack::MiniProfiler.authorize_request if current_admin_user.present? }
end
