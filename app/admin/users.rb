ActiveAdmin.register User do
  permit_params :company_member

  index do
    selectable_column
    id_column
    column :login
    actions
  end

  filter :id
  filter :login, label: 'GITHUB USERNAME'
  filter :company_member
  filter :github_id, label: 'GITHUB ID'
  filter :node_id
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :login
      row :company_member
      row :node_id
      row :github_id
      row :created_at
      row :updated_at
    end
  end
end
