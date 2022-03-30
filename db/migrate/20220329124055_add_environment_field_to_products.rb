class AddEnvironmentFieldToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :jira_boards, :environment_field, :string
  end
end
