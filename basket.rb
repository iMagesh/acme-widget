require_relative 'product_catalogue'
require_relative 'delivery_rule'

# Main basket class
class Basket
  def initialize(catalogue:, delivery_rule:)
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @items = []
  end

  def add(product_code)
    raise "Unknown product code: #{product_code}" unless @catalogue.valid_code?(product_code)
    @items << product_code
  end

  def total
    item_counts = @items.tally
    subtotal = 0.0

    item_counts.each do |code, count|
      subtotal += @catalogue.price(code) * count if count > 0
    end

    # Delivery charge
    delivery = @delivery_rule.charge(subtotal)
    total = subtotal + delivery
    format("$%.2f", total)
  end
end

# Usage example (uncomment to test)
PRODUCTS = {
  "R01" => { name: "Red Widget", price: 32.95 },
  "G01" => { name: "Green Widget", price: 24.95 },
  "B01" => { name: "Blue Widget", price: 7.95 }
}

DELIVERY_RULES = [
  { threshold: 50, charge: 4.95 },
  { threshold: 90, charge: 2.95 },
  { threshold: Float::INFINITY, charge: 0.0 }
]

catalogue = ProductCatalogue.new(PRODUCTS)

delivery_rule = DeliveryRule.new(DELIVERY_RULES)

basket = Basket.new(catalogue:, delivery_rule:)

basket.add("R01")
basket.add("R01")
puts basket.total
