class ProjectsAddDepartmentReference < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :department, foreign_key: true
  end
end
