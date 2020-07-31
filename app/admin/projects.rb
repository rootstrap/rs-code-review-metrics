ActiveAdmin.register Project do
  permit_params :language_id, :description, :name, :github_id, :relevance
  remove_filter :events

  index do
    selectable_column
    id_column
    column :github_id
    column :name
    column :description
    column :language_id do |r|
      r.language.name
    end
    column :relevance
    actions
  end

  form do |f|
    f.inputs do
      f.input :github_id
      f.input :name
      f.input :description, required: false
      f.input :language
      f.input :relevance, as: :radio, collection: Project.relevances.values
    end
    f.actions
  end
end
