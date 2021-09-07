class ProductService
  attr_accessor :product

  def initialize(product)
    @product = product
  end

  def update!(params)
    repositories_ids = params['repository_ids']

    update_repositories(repositories_ids, params['name']) if repositories_ids

    product.update!(params)
  end

  private

  def update_repositories(repositories_ids, name)
    product_id = Product.find_by(name: name)
    repositories = Repository.where(product_id: product_id)

    repositories.each do |repository|
      repository.update!(product_id: nil) unless repositories_ids.include?(repository.id)
    end
  end
end
