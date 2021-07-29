ActiveAdmin.register JiraProject do
  permit_params :jira_key, :jira_project_key, :project_name, :product_id

  index do
    selectable_column
    id_column
    column :jira_project_key
    column :project_name
    actions
  end

  filter :product
  filter :jira_project_key

  show do
    attributes_table do
      row :id
      row :jira_project_key
      row :project_name
      row :product
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :jira_project_key
      f.input :project_name, required: false
      f.input :product
      actions
    end
  end
end
