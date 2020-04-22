module ActionHelper
  def change_action_to(action)
    subject.payload['action'] = action
  end
end
