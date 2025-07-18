# Models the product catalogue
class ProductCatalogue
  def initialize(products)
    @products = products
  end

  def price(code)
    raise "Unknown product code: #{code}" unless valid_code?(code)
    prod = @products[code.to_s]
    prod ? prod['price'] || prod[:price] : nil
  end

  def valid_code?(code)
    @products.key?(code.to_s)
  end

  def [](code)
    @products[code.to_s]
  end
end
