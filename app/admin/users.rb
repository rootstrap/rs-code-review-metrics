ActiveAdmin.register User do
  permit_params :company_member

  index do
    id_column
    column :login
  end
end
