# Models the product catalogue
class ProductCatalogue
  def initialize(products)
    @products = products
  end

  def price(code)
    raise UnknownProductCodeError, "Unknown product code: #{code}" unless valid_code?(code)
    product = @products[code.to_s]
    product ? product['price'] || product[:price] : nil
  end

  def valid_code?(code)
    @products.key?(code.to_s)
  end

  def [](code)
    @products[code.to_s]
  end
end

class UnknownProductCodeError < StandardError; end