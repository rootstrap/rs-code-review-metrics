class CreateCodeClimateProjectMetrics < ActiveRecord::Migration[6.0]
  def change
    create_table :code_climate_project_metrics do |t|
      t.references :project, null: false, foreign_key: true
      t.string :code_climate_rate
      t.integer :invalid_issues_count
      t.integer :wont_fix_issues_count

      t.timestamps
    end
  end
end
