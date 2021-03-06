ExceptionHunter.setup do |config|
  # == Current User
  #
  # Exception Hunter will include the user as part of the environment
  # data, if it was to be available. The default configuration uses devise
  # :current_user method. You can change it in case you named your user model
  # in some other way (i.e. Member). You can also remove the configuration if
  # you don't wish to track user data.
  #
  config.current_user_method = :current_admin_user

  # == Current User Attributes
  #
  # Exception Hunter will try to include the attributes defined here
  # as part of the user information that is kept from the request.
  #
  config.user_attributes = %i[id email]
end
