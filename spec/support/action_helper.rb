module ActionHelper
  def change_action_to(action)
    payload.merge!('action' => action)
  end
end
