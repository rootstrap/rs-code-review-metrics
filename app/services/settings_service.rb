module SettingsService
  extend self

  def success_rate(department_name, metric_name)
    Setting.success_rate(department_name, metric_name).first&.value&.to_i || 24
  end

  def enabled_users_section
    Setting.enabled('users_section').first&.value == 'true' || false
  end

  def enabled_department_per_tech_graph
    Setting.enabled('department_per_tech_graph').first&.value == 'true' || false
  end

  def enabled_project_per_user_graph
    Setting.enabled('project_per_user_graph').first&.value == 'true' || false
  end

  def enabled_project_codeowners_section
    Setting.enabled('project_codeowners_section').first&.value == 'true' || false
  end
end
