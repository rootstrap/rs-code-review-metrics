class ApplicationController < ActionController::Base
  before_action :set_robots_noindex_header
  before_action :authenticate_admin_user!, unless: :devise_controller?
  before_action { Rack::MiniProfiler.authorize_request if current_admin_user.present? }

  private

  # Keep every response out of search engines. This is an internal, admin-only
  # tool, so we never want its pages (including the login screen) indexed.
  def set_robots_noindex_header
    response.set_header('X-Robots-Tag', 'noindex, nofollow, noarchive')
  end
end
