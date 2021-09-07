module LoadSettings
  extend ActiveSupport::Concern

  included do
    before_action :load_settings
  end

  private

  def load_settings
    enabled_users_section
    enabled_department_per_tech_graph
    enabled_repository_codeowners_section
    enabled_repository_per_user_graph
  end

  def enabled_users_section
    @enabled_users_section ||= SettingsService.enabled_users_section
  end

  def enabled_department_per_tech_graph
    @enabled_department_per_tech_graph ||= SettingsService.enabled_department_per_tech_graph
  end

  def enabled_repository_codeowners_section
    @enabled_repository_codeowners_section ||= SettingsService.enabled_repository_codeowners_section
  end

  def enabled_repository_per_user_graph
    @enabled_repository_per_user_graph ||= SettingsService.enabled_repository_per_user_graph
  end
end
