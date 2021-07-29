class ProductService
  attr_accessor :product

  def initialize(product)
    @product = product
  end

  def update!(params)
    project_ids = params['project_ids']

    update_projects(project_ids, params['name']) if project_ids

    product.update!(params)
  end

  private

  def update_projects(project_ids, name)
    product_id = Product.find_by(name: name)
    projects = Project.where(product_id: product_id)

    projects.each do |project|
      project.update!(product_id: nil) unless project_ids.include?(project.id)
    end
  end
end
