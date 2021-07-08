class CreateProductsMetricsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :metrics do |t|
      t.index %i[product_id metric_id]
    end
  end
end
