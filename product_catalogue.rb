# Models the product catalogue
class ProductCatalogue
  def initialize(products)
    @products = products
  end

  def price(code)
    raise "Unknown product code: #{code}" unless valid_code?(code)
    @products[code][:price]
  end

  def valid_code?(code)
    @products.key?(code)
  end

  def [](code)
    @products[code]
  end
end
