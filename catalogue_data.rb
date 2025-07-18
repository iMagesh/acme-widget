# catalogue_data.rb
# Product, delivery, and offer data for Acme Widget Co

require_relative 'offers/all'

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

CATALOGUE = ProductCatalogue.new(PRODUCTS)
DELIVERY = DeliveryRule.new(DELIVERY_RULES)
OFFERS = [BuyOneGetOneHalfPrice.new("R01")]
