module AdminUsers
  # Serves the sign-in page with the Engineering Metrics styling instead of the
  # default Active Admin login screen. All other Devise behaviour is inherited.
  class SessionsController < ActiveAdmin::Devise::SessionsController
    layout 'devise'
  end
end
