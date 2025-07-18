# catalogue_data.rb
# Product, delivery, and offer data for Acme Widget Co

require 'yaml'
require_relative 'offers/all'

PRODUCTS = YAML.load_file(File.join(__dir__, 'config/products.yml'))

raw_delivery_rules = YAML.load_file(File.join(__dir__, 'config/delivery_rules.yml'))

DELIVERY_RULES = raw_delivery_rules.map do |rule|
  threshold = rule['threshold'] == 'Infinity' ? Float::INFINITY : rule['threshold']
  { threshold: threshold, charge: rule['charge'] }
end

CATALOGUE = ProductCatalogue.new(PRODUCTS)
DELIVERY = DeliveryRule.new(DELIVERY_RULES)
OFFERS = [BuyOneGetOneHalfPrice.new("R01")]
