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
    subtotal = apply_offers(item_counts)
    subtotal += remaining_items_total(item_counts)
    delivery = delivery_charge(subtotal)
    total = subtotal + delivery
    format("$%.2f", total)
  end

  private

  def apply_offers(item_counts)
    total = BigDecimal("0.0")
    @offers.each do |offer|
      total += BigDecimal(offer.apply(item_counts, @catalogue).to_s)
    end
    total
  end

  def remaining_items_total(item_counts)
    total = BigDecimal("0.0")
    item_counts.each do |code, count|
      if count > 0
        price = BigDecimal(@catalogue.price(code).to_s).truncate(2)
        total += price * count
      end
    end
    total
  end

  def delivery_charge(subtotal)
    subtotal == 0 ? 0.0 : @delivery_rule.charge(subtotal.to_f)
  end
end

# Usage example (uncomment to test)
basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
basket.add("R01")
basket.add("R01")
puts basket.total