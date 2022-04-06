class JiraBoardService
  attr_accessor :jira_board

  def update!(params)
    @jira_board = JiraBoard.find_by(id: params['id'])
    jira_board.update!(update_params(params))
    update_environments(params)
    jira_board
  end

  def create!(params)
    @jira_board = JiraBoard.create!(update_params(params))
    update_environments(params)
    jira_board
  end

  private

  def update_jira_board(params)
    jira_board.jira_project_key= params['jira_project_key']
    jira_board.environment_field= params['environment_field']
    jira_board.project_name= params['project_name']
    jira_board.product_id= params['product_id']
    JiraBoard.update!(jira_board)
  end

  def update_environments(params)
    update_custom_environment(params['id'], params['jira_environments_qa'], 'qa') if params['jira_environments_qa']
    update_custom_environment(params['id'], params['jira_environments_development'], 'development') if params['jira_environments_development']
    update_custom_environment(params['id'], params['jira_environments_staging'], 'staging') if params['jira_environments_staging']
    update_custom_environment(params['id'], params['jira_environments_production'], 'production') if params['jira_environments_production']
  end

  def update_custom_environment( id, custom_environment, jira_environment)
      jira_board.jira_environments.where(environment: jira_environment).delete_all
      custom_environment.split(",").each do |environment|
        jira_board.jira_environments.create!(environment: jira_environment, custom_environment:environment)
      end
  end

  def update_params(params)
   params.except('jira_environments_development','jira_environments_qa', 'jira_environments_staging', 'jira_environments_production')
  end

end
