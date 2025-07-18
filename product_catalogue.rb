# Models the product catalogue
class ProductCatalogue
  def initialize(products)
    @products = products
  end

  def price(code)
    @products[code][:price]
  end

  def valid_code?(code)
    @products.key?(code)
  end

  def [](code)
    @products[code]
  end
end
