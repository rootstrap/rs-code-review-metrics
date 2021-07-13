ActiveAdmin.register Product do
  permit_params :description, :name

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  filter :name
  filter :description
end
