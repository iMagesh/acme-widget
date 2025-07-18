# test_basket.rb
# Simple unit tests for Acme Widget Co basket

require_relative '../basket'

# Runs a basket test and prints the result.
# products: array of product codes
# expected: expected total as string
def test_basket(products, expected, comment)
  basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
  products.each { |code| basket.add(code) }
  result = basket.total
  status = result == expected ? "PASS" : "FAIL"
  puts "#{status}: #{products.join(', ')} => #{result} (expected #{expected})\n  Scenario: #{comment}"
  puts "#{'-'*60}"
end

puts "Running basket tests..."

test_cases = [
  {
    products: ["B01", "G01"],
    expected: "$37.85",
    comment: "Blue + Green, no offers, subtotal $37.85, delivery $0.00"
  },

  {
    products: ["R01", "R01"],
    expected: "$54.37",
    comment: "2x Red, offer applies: $32.95 + $16.47 = $49.42, delivery $4.95, total $54.37"
  },

  {
    products: ["R01", "G01"],
    expected: "$60.85",
    comment: "Red + Green, no offer, subtotal $57.90, delivery $2.95, total $60.85"
  },

  {
    products: ["B01", "B01", "R01", "R01", "R01"],
    expected: "$98.27",
    comment: "2x Blue, 3x Red, offer applies to 1 pair: $49.42 + $32.95 + $15.90 = $98.27, delivery $0.00"
  },

  {
    products: [],
    expected: "$0.00",
    comment: "Empty basket, total $0.00"
  },

  {
    products: ["B01"],
    expected: "$12.90",
    comment: "1x Blue, subtotal $7.95, delivery $4.95, total $12.90"
  },

  {
    products: ["G01"],
    expected: "$29.90",
    comment: "1x Green, subtotal $24.95, delivery $4.95, total $29.90"
  },

  {
    products: ["R01"],
    expected: "$37.90",
    comment: "1x Red, subtotal $32.95, delivery $4.95, total $37.90"
  },

  {
    products: ["R01", "R01", "R01"],
    expected: "$85.32",
    comment: "3x Red, offer applies to 1 pair: $49.42 + $32.95 = $82.37, delivery $2.95, total $85.32"
  },

  {
    products: ["R01", "R01", "R01", "R01", "G01", "B01"],
    expected: "$131.74",
    comment: "4x Red (2 pairs), 1x Green, 1x Blue: $98.84 + $24.95 + $7.95 = $131.74, delivery $0.00"
  },

  {
    products: ["B01", "B01", "B01", "B01", "B01", "B01"],
    expected: "$52.65",
    comment: "6x Blue, subtotal $47.70, delivery $4.95, total $52.65"
  },

  {
    products: ["G01", "G01", "G01"],
    expected: "$77.80",
    comment: "3x Green, subtotal $74.85, delivery $2.95, total $77.80"
  },

  {
    products: ["G01", "G01"],
    expected: "$54.85",
    comment: "2x Green, subtotal $49.90, delivery $4.95, total $54.85"
  },

  {
    products: ["G01", "G01", "B01"],
    expected: "$60.80",
    comment: "2x Green, 1x Blue, subtotal $57.85, delivery $2.95"
  }
]

test_cases.each { |tc| test_basket(tc[:products], tc[:expected], tc[:comment]) }

# Invalid product code (should raise error)
begin
  test_basket(["INVALID"], "ERROR", "Invalid product code should raise error")
rescue => e
  puts "PASS: INVALID => ERROR (raised #{e.class})"
end