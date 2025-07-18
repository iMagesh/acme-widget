require_relative 'product_catalogue'

# Main basket class
class Basket
  def initialize(catalogue:)
    @catalogue = catalogue
    @items = []
  end

  def add(product_code)
    raise "Unknown product code" unless @catalogue.valid_code?(product_code)
    @items << product_code
  end

  def total
    item_counts = @items.tally
    subtotal = 0.0

    item_counts.each do |code, count|
      subtotal += @catalogue.price(code) * count if count > 0
    end
    return subtotal
  end
end

# Usage example (uncomment to test)
PRODUCTS = {
  "R01" => { name: "Red Widget", price: 32.95 },
  "G01" => { name: "Green Widget", price: 24.95 },
  "B01" => { name: "Blue Widget", price: 7.95 }
}

CATALOGUE = ProductCatalogue.new(PRODUCTS)

basket = Basket.new(catalogue: CATALOGUE)
basket.add("B01")
basket.add("G01")
puts basket.total
