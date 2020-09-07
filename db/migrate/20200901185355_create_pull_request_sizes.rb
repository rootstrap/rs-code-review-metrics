class CreatePullRequestSizes < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_request_sizes do |t|
      t.references :pull_request, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
