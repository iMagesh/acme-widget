require 'bigdecimal'
require 'bigdecimal/util'

require_relative 'product_catalogue'
require_relative 'delivery_rule'
require_relative 'offers/all' # Load all offers
# --- Data setup ---
require_relative 'catalogue_data'

# Main basket class
class Basket
  def initialize(catalogue:, delivery_rule:, offers: [])
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @items = []
    @offers = offers
  end

  def add(product_code)
    raise "Unknown product code: #{product_code}" unless @catalogue.valid_code?(product_code)
    @items << product_code
  end

  def total
    item_counts = @items.tally
    subtotal = BigDecimal("0.0")

    # Apply all offers (each can mutate item_counts)
    @offers.each do |offer|
      subtotal += BigDecimal(offer.apply(item_counts, @catalogue).to_s)
    end

    # Add remaining items not covered by offers
    item_counts.each do |code, count|
      subtotal += BigDecimal(@catalogue.price(code).to_s) * count if count > 0
    end

    # Retail rounding (truncate to 2 decimals)
    subtotal = subtotal.truncate(2)
    delivery = subtotal == 0 ? 0.0 : @delivery_rule.charge(subtotal.to_f)
    total = subtotal + delivery
    format("$%.2f", total)
  end
end

# Usage example (uncomment to test)
basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
basket.add("R01")
basket.add("R01")
puts basket.total # => "$37.85"