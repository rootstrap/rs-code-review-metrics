module ActionHelper
  def change_action_to(action)
    payload['action'] = action
  end
end
