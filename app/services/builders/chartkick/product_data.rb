module Builders
  module Chartkick
    class ProductData < Builders::Chartkick::Base
      def call
        product = ::Product.find(@entity_id)

        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerProduct
                  .call(product.id, @query[:value_timestamp])
        [{ name: product.name, data: build_data(metrics) }]
      end
    end
  end
end
