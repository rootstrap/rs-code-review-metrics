class AddJiraProjectKeyToProduct < ActiveRecord::Migration[6.0]
  def up
    add_column :products, :jira_project_key, :string

    Product.with_deleted.find_each do |product|
      product.update(jira_project_key: product.jira_project&.jira_project_key)
    end
  end

  def down
    remove_colum :products, :jira_project_key, :string, null: false
  end
end
