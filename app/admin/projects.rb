ActiveAdmin.register Project do
  permit_params :language_id, :description, :name, :github_id, :relevance

  index do
    selectable_column
    id_column
    column :github_id
    column :jira_key
    column :name
    column :description
    column :language_id do |r|
      r.language.name
    end
    column :relevance
    actions
  end

  show do
    attributes_table(*default_attribute_table_rows) do
      row :jira_key
    end
  end

  filter :name
  filter :is_private
  filter :jira_key, label: 'Jira Project Key'
  filter :github_id, label: 'GITHUB ID'
  filter :relevance, as: :select, collection: Project.relevances.values
  filter :language, as: :select, collection: Language.order('LOWER(name)')
  filter :users, collection: User.order('LOWER(login)')
  filter :code_owners, collection: User.order('LOWER(login)')
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :github_id
      f.input :jira_key, label: 'Jira Project Key'
      f.input :name
      f.input :description, required: false
      f.input :language
      f.input :relevance, as: :radio, collection: Project.relevances.values
    end
    f.actions
  end
end
