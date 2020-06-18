ActiveAdmin.register Project do
  permit_params :lang
  remove_filter :events
  filter :lang, label: 'Language', as: :select, collection: Project.langs

  index do
    id_column
    column :name
    column :description
    column :lang
  end

  form do |f|
    f.inputs 'Edit Project' do
      f.input :lang, label: 'Language', as: :select, collection: Project.langs
    end
    f.actions
  end
end
