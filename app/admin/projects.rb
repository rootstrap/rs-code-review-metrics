ActiveAdmin.register Project do
  ## TODO
  # permit_params :language
  remove_filter :events
  # filter :language, label: 'Language', as: :select, collection: Language.pluck(:name)

  index do
    id_column
    column :name
    column :description
    # column :language
  end

  # form do |f|
  #   f.inputs 'Edit Project' do
  #     f.input :language, label: 'Language', as: :select, collection: Language.pluck(:name)
  #   end
  #   f.actions
  # end
end
