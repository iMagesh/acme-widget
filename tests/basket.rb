# test_basket.rb
# Simple unit tests for Acme Widget Co basket

require_relative '../basket'

# Prints the result of a basket test in a consistent format
def print_test_result(status, products, result, expected, comment)
  puts "#{status}:" 
  puts " Scenario: #{comment}\n\n"
  puts " Products: #{products.join(', ')}" 
  puts " Results: => #{result} (expected #{expected})"
  puts "#{'-'*60}\n\n"
end

# Runs a basket test and prints the result.
# products: array of product codes
# expected: expected total as string
def test_basket(products, expected, comment)
  basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
  products.each { |code| basket.add(code) }
  result = basket.total
  status = result == expected ? "PASS" : "FAIL"
  print_test_result(status, products, result, expected, comment)
end

puts "Running basket tests..."

test_cases = [
  # Basic basket scenarios
  {
    products: ["B01", "G01"],
    expected: "$37.85",
    comment: "Blue + Green, no offers, subtotal $37.85, delivery $4.95"
  },

  # Red widget offer scenarios
  {
    products: ["R01", "R01"],
    expected: "$54.37",
    comment: "2x Red, offer applies: $32.95 + $16.47 = $49.42, delivery $4.95, total $54.37"
  },

  # Mixed basket scenarios
  {
    products: ["R01", "G01"],
    expected: "$60.85",
    comment: "Red + Green, no offer, subtotal $57.90, delivery $2.95, total $60.85"
  },

  # Large basket scenarios
  {
    products: ["B01", "B01", "R01", "R01", "R01"],
    expected: "$98.27",
    comment: "2x Blue, 3x Red, offer applies to 1 pair: $49.42 + $32.95 + $15.90 = $98.27, delivery $0.00"
  },

  # Empty basket scenario
  {
    products: [],
    expected: "$0.00",
    comment: "Empty basket, total $0.00"
  },

  # Single item scenarios
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

  # Odd numbers of red widgets
  {
    products: ["R01", "R01", "R01"],
    expected: "$85.32",
    comment: "3x Red, offer applies to 1 pair: $49.42 + $32.95 = $82.37, delivery $2.95, total $85.32"
  },
  {
    products: ["R01", "R01", "R01", "R01", "R01"],
    expected: "$131.79",
    comment: "5x Red, 2 pairs with offer ($49.42 x2), 1x full price ($32.95), subtotal $131.79, delivery $0, total $131.79"
  },
  {
    products: ["R01", "R01", "R01", "R01", "R01", "R01", "R01"],
    expected: "$181.21",
    comment: "7x Red, 3 pairs with offer ($49.42 x3), 1 full-price ($32.95), subtotal $181.21, delivery $0.00, total $181.21"
  },
  # Delivery threshold boundaries
  {
    products: ["B01", "B01", "B01", "B01", "B01", "B01", "B01"],
    expected: "$58.60",
    comment: "7x Blue, subtotal $55.65, delivery $2.95 (mid-tier threshold applied), total $58.60"
  },
  {
    products: ["G01", "G01", "G01", "G01"],
    expected: "$99.80",
    comment: "4x Green, subtotal $99.80, delivery $0.00 (free delivery threshold met)"
  },
  # Basket with only one red widget (no offer)
  {
    products: ["R01"],
    expected: "$37.90",
    comment: "1x Red, no offer, subtotal $32.95, delivery $4.95, total $37.90"
  },
  # Duplicate offer scenario for two red widgets
  {
    products: ["R01", "R01"],
    expected: "$54.37",
    comment: "2x Red, offer applies: $32.95 + $16.47 = $49.42, delivery $4.95, total $54.37 (duplicate offer test)"
  },

  # Mixed large basket scenario
  {
    products: ["R01", "R01", "R01", "R01", "G01", "B01"],
    expected: "$131.74",
    comment: "4x Red (2 pairs), 1x Green, 1x Blue: $98.84 + $24.95 + $7.95 = $131.74, delivery $0.00"
  },

  # Multiple blue widgets scenario
  {
    products: ["B01", "B01", "B01", "B01", "B01", "B01"],
    expected: "$52.65",
    comment: "6x Blue, subtotal $47.70, delivery $4.95, total $52.65"
  },

  # Multiple green widgets scenario
  {
    products: ["G01", "G01", "G01"],
    expected: "$77.80",
    comment: "3x Green, subtotal $74.85, delivery $2.95, total $77.80"
  },

  # Two green widgets scenario
  {
    products: ["G01", "G01"],
    expected: "$54.85",
    comment: "2x Green, subtotal $49.90, delivery $4.95, total $54.85"
  },

  # Green and blue widgets scenario
  {
    products: ["G01", "G01", "B01"],
    expected: "$60.80",
    comment: "2x Green, 1x Blue, subtotal $57.85, delivery $2.95"
  }
]

test_cases.each do |test_case| 
  test_basket(test_case[:products], test_case[:expected], test_case[:comment])
end

# Invalid product code (should raise error)
begin
  test_basket(["INVALID"], "ERROR", "Invalid product code should raise error")
rescue UnknownProductCodeError => e
  puts "PASS: INVALID => ERROR (raised #{e.class})"
end