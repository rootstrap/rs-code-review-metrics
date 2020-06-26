class RemoveDepartmentProjectRelation < ActiveRecord::Migration[6.0]
  def change
    remove_reference :projects, :department
  end
end
