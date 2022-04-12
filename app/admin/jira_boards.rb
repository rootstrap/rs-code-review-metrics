ActiveAdmin.register JiraBoard do
  permit_params :id, :jira_key, :jira_project_key, :environment_field, :project_name, :product_id,
                :jira_environments_development, :jira_environments_qa, :jira_environments_staging,
                :jira_environments_production

  index do
    selectable_column
    id_column
    column :jira_project_key
    column :project_name
    column :environment_field
    actions
  end

  filter :product
  filter :jira_project_key
  filter :environment_field

  show do
    attributes_table do
      row :id
      row :jira_project_key
      row :project_name
      row :product
      row :created_at
      row :updated_at
      row :environment_field
      row :jira_environments_development
      row :jira_environments_staging
      row :jira_environments_qa
      row :jira_environments_production
    end
  end

  form do |f|
    f.inputs 'Board' do
      f.input :id, as: :hidden
      f.input :jira_project_key
      f.input :project_name, required: false
      f.input :product
    end

    f.inputs 'Environments' do
      f.input :environment_field
      f.input :jira_environments_development, as: :tags, label: 'Development name'
      f.input :jira_environments_staging, as: :tags, label: 'Staging name'
      f.input :jira_environments_qa, as: :tags, label: 'QA name'
      f.input :jira_environments_production, as: :tags, label: 'Production name'
    end

    actions
  end

  controller do
    def update
      jira_board_service = JiraBoardService.new
      respond_to do |format|
        jira_board = jira_board_service.update!(resource_params[0])
        format.html { redirect_to admin_jira_board_path(jira_board) }
        format.json { render json: jira_board }
      end
    end

    def create
      jira_board_service = JiraBoardService.new
      respond_to do |format|
        jira_board = jira_board_service.create!(resource_params[0])
        format.html { redirect_to admin_jira_board_path(jira_board) }
        format.json { render json: jira_board }
      end
    end
  end
end
