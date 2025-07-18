# test_basket.rb
# Simple unit tests for Acme Widget Co basket

require_relative '../basket'

# Helper to run a basket test
# products: array of product codes
# expected: expected total as string
#
def test_basket(products, expected)
  basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
  products.each { |code| basket.add(code) }
  result = basket.total
  if result == expected
    puts "PASS: #{products.join(', ')} => #{result}"
  else
    puts "FAIL: #{products.join(', ')} => #{result} (expected #{expected})"
  end
end

puts "Running basket tests..."

test_basket(["B01", "G01"], "$37.85")
test_basket(["R01", "R01"], "$54.37")
test_basket(["R01", "G01"], "$60.85")
test_basket(["B01", "B01", "R01", "R01", "R01"], "$98.27")
