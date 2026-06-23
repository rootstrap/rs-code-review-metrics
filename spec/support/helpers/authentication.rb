module AuthenticationHelper
  def sign_in_admin_user
    sign_in(create(:admin_user))
  end
end

# Every browser-facing endpoint now sits behind `authenticate_admin_user!`
# (see ApplicationController). Sign a default admin in for request and controller
# specs so they exercise the protected behaviour. Tag an example or group with
# `unauthenticated: true` to opt out (e.g. the public webhook, or specs that
# assert the redirect to the login page).
RSpec.configure do |config|
  config.include AuthenticationHelper

  %i[request controller].each do |spec_type|
    config.before(:each, type: spec_type) do |example|
      sign_in_admin_user unless example.metadata[:unauthenticated]
    end
  end
end
