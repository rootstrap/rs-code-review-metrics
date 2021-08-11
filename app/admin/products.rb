ActiveAdmin.register Product do
  permit_params :id, :description, :name, :jira_key, :new_jira_key,
                jira_board_attributes: %i[id jira_project_key],
                project_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :jira_project_key do |product|
      product.jira_board&.jira_project_key
    end
    actions
  end

  show do
    attributes_table(*default_attribute_table_rows) do
      attributes_table_for product.jira_board do
        row :jira_project_key
      end

      table_for product.projects.order(:name) do
        column 'Projects' do |project|
          link_to project.name, [:admin, project]
        end
      end
    end
  end

  filter :name
  filter :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, required: false
      if object.jira_board
        f.inputs for: [:jira_board, f.object.jira_board] do |s|
          s.input :jira_project_key
        end
      else
        f.inputs for: [:jira_board, f.object.jira_board || JiraBoard.new] do |s|
          s.input :jira_project_key, required: false
        end
      end

      f.input :projects,
              as: :check_boxes,
              collection: Project.order(:name)
    end
    f.actions
  end

  controller do
    def update
      @product = resource
      product_service = ProductService.new(@product)

      respond_to do |format|
        product_service.update!(resource_params[0])
        format.html { redirect_to admin_product_path(@product) }
        format.json { render json: @product }
      end
    end
  end
end
