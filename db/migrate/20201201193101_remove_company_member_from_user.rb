class RemoveCompanyMemberFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :company_member, :boolean
  end
end
