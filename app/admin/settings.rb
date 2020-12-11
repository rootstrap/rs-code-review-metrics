ActiveAdmin.register Setting do
  permit_params :value, :description

  actions :all, except: :destroy
end
