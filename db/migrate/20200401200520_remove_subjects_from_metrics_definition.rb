class RemoveSubjectsFromMetricsDefinition < ActiveRecord::Migration[6.0]
  def change

    remove_column :metrics_definitions, :subject, :string
  end
end
