ActiveAdmin.register Product do
  permit_params :id, :description, :name, :jira_project_key, project_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :jira_project_key
    actions
  end

  filter :name
  filter :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, required: false
      f.input :jira_project_key, required: false
      f.input :projects, as: :check_boxes
    end
    f.actions
  end
end
