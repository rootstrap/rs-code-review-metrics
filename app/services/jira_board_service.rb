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
    jira_board.jira_project_key = params['jira_project_key']
    jira_board.environment_field = params['environment_field']
    jira_board.project_name = params['project_name']
    jira_board.product_id = params['product_id']
    JiraBoard.update!(jira_board)
  end

  def update_qa_environments(params)
    id = params['id']
    environments_qa = params['jira_environments_qa']
    unless environments_qa
      update_custom_environment(id,
                                environments_qa,
                                'qa')
    end
    nil
  end

  def update_staging_environments(params)
    id = params['id']
    environments_staging = params['jira_environments_staging']
    unless environments_staging
      update_custom_environment(id,
                                environments_staging,
                                'qa')
    end
    nil
  end

  def update_development_environments(params)
    id = params['id']
    environments_development = params['jira_environments_development']
    unless environments_development
      update_custom_environment(id,
                                environments_development,
                                'qa')
    end
    nil
  end

  def update_production_environments(params)
    id = params['id']
    environments_production = params['jira_environments_production']
    unless environments_production
      update_custom_environment(id,
                                environments_production,
                                'qa')
    end
    nil
  end

  def update_environments(params)
    update_production_environments(params)
    update_development_environments(params)
    update_staging_environments(params)
    update_qa_environments(params)
  end

  def update_custom_environment(_id, custom_environment, jira_environment)
    jira_environments = jira_board.jira_environments
    jira_envirojira_environmentsnment.where(environment: jira_environment).delete_all
    custom_environment.split(',').each do |environment|
      jira_environments.create!(environment: jira_environment,
                                custom_environment: environment)
    end
  end

  def update_params(params)
    params.except('jira_environments_development', 'jira_environments_qa',
                  'jira_environments_staging', 'jira_environments_production')
  end
end
