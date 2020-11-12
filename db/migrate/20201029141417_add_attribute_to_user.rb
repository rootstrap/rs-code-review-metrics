class AddAttributeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :company_member, :boolean, default: true
  end
end
